//
//  PlaceDetailsViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

final class PlaceDetailsViewModel: PlaceDetailsViewModelProtocol {
    
    init(withService service: PlaceDetailsServiceProtocol) {
        self.service = service
        self.service.delegate = self
    }
    
    fileprivate var service: PlaceDetailsServiceProtocol
    
    fileprivate var model: PlaceModel? = nil {
        didSet {
            updateViewModel()
        }
    }
    
    
    // MARK: Constants
    
    fileprivate let defaultError = "An error occured, please try again later"
    
    
    // MARK: Protocol properties
    
    weak var delegate: PlaceDetailsViewModelDelegate?
    
    fileprivate(set) var showLoadingIndicator: Bool = false
    fileprivate(set) var showError: Bool = false
    fileprivate(set) var showContentView: Bool = false
    
    var titleText: String? {
        return "Place Details"
    }
    fileprivate(set) var errorText: String?
    fileprivate(set) var nameText: String?    
    fileprivate(set) var ratingText: String?
    
    var shouldProccessAddressClicks: Bool {
        return model?.url != nil
    }
    fileprivate(set) var addressText: NSAttributedString?
    
    var shouldProccessPhoneClicks: Bool {
        return model?.phoneUrl != nil
    }
    fileprivate(set) var phoneText: NSAttributedString?
    
    var shouldProccessWebsiteClicks: Bool {
        return model?.website != nil
    }
    fileprivate(set) var websiteText: NSAttributedString?
    
    fileprivate(set) var showIcon: Bool = false
    fileprivate(set) var icon: UIImage?
    
    fileprivate(set) var photos: [PlacePhotoViewModelProtocol] = []
    
    
    // MARK: Protocol functions
    
    func loadDetails() {
        // Show loading indicator and hide the other components
        showLoadingIndicator = true
        showError = false
        showContentView = false
        
        delegate?.placeDetailsViewModelUpdated(self)
        
        service.loadDetails()
    }
    
    func onPhoneClicked() {
        if let url = model?.phoneUrl {
            delegate?.shouldOpenLink(link: url, from: self)
        }
    }
    
    func onAddressClicked() {
        if let url = model?.url {
            delegate?.shouldOpenLink(link: url, from: self)
        }
    }
    
    func onWebsiteClicked() {
        if let url = model?.website {
            delegate?.shouldOpenLink(link: url, from: self)
        }
    }
}


// MARK: UI attributes

extension PlaceDetailsViewModel {
    
    fileprivate var propertyLabelFont: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    
    fileprivate var propertyLabelColor: UIColor {
        return UIColor.gray
    }
    
    func propertyAttributes() -> [String: Any] {
        return [NSFontAttributeName: propertyLabelFont,
                NSForegroundColorAttributeName: propertyLabelColor]
    }
    
    func clickablePropertyAttributes() -> [String: Any] {
        var attributes = propertyAttributes()
        attributes[NSUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue
        return attributes
    }
}


// MARK: Updating UI

extension PlaceDetailsViewModel {
    
    fileprivate func updateViewModel() {
        guard let model = model else {
            return
        }
        
        nameText = model.name
        
        updateRating()
        updateAddress()
        updatePhone()
        updateWebsite()
        updateIcon()
        updatePhotos()
    }
    
    private func updateRating() {
        if let rating = model?.rating, rating > 0 {
            ratingText = "Rating: \(rating)"
        } else {
            ratingText = nil
        }
    }
    
    private func updateAddress() {
        if let address = model?.address {
            let attributes = model?.url != nil ? clickablePropertyAttributes() : propertyAttributes()
            addressText = NSAttributedString(string: address, attributes: attributes)
        } else {
            if model?.url != nil {
                addressText = NSAttributedString(string: "Click to open address on the map", attributes: propertyAttributes())
            } else {
                addressText = nil
            }
        }
    }
    
    private func updatePhone() {
        if let phone = model?.phone {
            phoneText = NSAttributedString(string: phone, attributes: clickablePropertyAttributes())
        } else {
            phoneText = nil
        }
    }
    
    private func updateWebsite() {
        if let url = model?.website {
            websiteText = NSAttributedString(string: url.absoluteString,  attributes: clickablePropertyAttributes())
        } else {
            websiteText = nil
        }
    }
    
    private func updateIcon() {
        if let url = model?.icon {
            showIcon = true
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.icon = image
                    self.delegate?.placeDetailsViewModelUpdated(self)
                }
            }).resume()
        } else {
            showIcon = false
        }
    }
    
    private func updatePhotos() {
        photos.removeAll()
        
        guard let model = model else {
            return
        }
        
        for photoUrl in model.photos {
            let photoViewModel = PlacePhotoViewModel(with: photoUrl)
            photos.append(photoViewModel)
        }
    }
}


// MARK: PlaceDetailsServiceDelegate
extension PlaceDetailsViewModel: PlaceDetailsServiceDelegate {
    func placeDetailsServiceDidUpdate(_ service: PlaceDetailsServiceProtocol) {
        // Check that model is exists
        var isShowingContent = false
        if let model = service.place {
            isShowingContent = true
            self.model = model
        } else {
            errorText = defaultError
        }
        
        showError = !isShowingContent
        showLoadingIndicator = !isShowingContent
        showContentView = isShowingContent
        
        delegate?.placeDetailsViewModelUpdated(self)
    }
    
    func placeDetailsService(_ service: PlaceDetailsServiceProtocol, didFailToUpdate error: Error) {
        // Show error and hide the other components
        errorText = defaultError
        showError = true
        showLoadingIndicator = false
        showContentView = false
        
        delegate?.placeDetailsViewModelUpdated(self)
    }
}
