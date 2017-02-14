//
//  PlaceDetailsViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PlaceDetailsViewModel: PlaceDetailsViewModelProtocol {
    
    fileprivate var service: PlaceDetailsServiceProtocol
    fileprivate var model: PlaceModel? = nil {
        didSet {
            updateViewModel()
        }
    }
    
    init(withService service: PlaceDetailsServiceProtocol) {
        self.service = service
        self.service.delegate = self
    }
    
    
    // MARK: UI Attributes
    
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
    
    
    // MARK: Protocol
    
    var delegate: PlaceDetailsViewModelDelegate?
    
    func loadDetails() {
        // Show loading indicator and hide the other components
        self.showLoadingIndicator = true
        self.showError = false
        self.showContentView = false
        
        delegate?.placeDetailsViewModelUpdated(self)
        
        self.service.loadDetails()
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
    
    var titleText: String? {
        return "Place Details"
    }
    
    fileprivate(set) var showLoadingIndicator: Bool = false
    
    fileprivate(set) var errorText: String?
    fileprivate(set) var showError: Bool = false
    
    fileprivate(set) var showContentView: Bool = false
    fileprivate(set) var nameText: String?
    fileprivate(set) var ratingText: String?
    
    var shouldProccessAddressClicks: Bool {
        return model?.url != nil
    }
    var displayAddress: Bool {
        return addressText != nil
    }
    fileprivate(set) var addressText: NSAttributedString?
    
    var shouldProccessPhoneClicks: Bool {
        return model?.phoneUrl != nil
    }
    var displayPhone: Bool {
        return phoneText != nil
    }
    fileprivate(set) var phoneText: NSAttributedString?
    
    var shouldProccessWebsiteClicks: Bool {
        return model?.website != nil
    }
    var displayWebsite: Bool {
        return websiteText != nil
    }
    fileprivate(set) var websiteText: NSAttributedString?
    
    fileprivate(set) var showIcon: Bool = false
    fileprivate(set) var icon: UIImage?
    
    // MARK: Update model
    
    private func updateViewModel() {
        guard let model = self.model else {
            return
        }
        
        nameText = model.name
        
        updateRating()
        updateAddress()
        updatePhone()
        updateWebsite()
        updateIcon()
    }
    
    private func updateRating() {
        if let rating = self.model?.rating, rating > 0 {
            self.ratingText = "Rating: \(rating)"
        } else {
            self.ratingText = "No rating"
        }
    }
    
    private func updateAddress() {
        if let address = model?.address {
            let attributes = model?.url != nil ? clickablePropertyAttributes() : propertyAttributes()
            self.addressText = NSAttributedString(string: address, attributes: attributes)
        } else {
            if model?.url != nil {
                self.addressText = NSAttributedString(string: "Click to open address on the map", attributes: propertyAttributes())
            } else {
                self.addressText = nil
            }
        }
    }
    
    private func updatePhone() {
        if let phone = model?.phone {
            self.phoneText = NSAttributedString(string: phone, attributes: clickablePropertyAttributes())
        } else {
            self.phoneText = nil
        }
    }
    
    private func updateWebsite() {
        if let url = model?.website {
            self.websiteText = NSAttributedString(string: url.absoluteString,  attributes: clickablePropertyAttributes())
        } else {
            self.websiteText = nil
        }
    }
    
    private func updateIcon() {
        if let url = model?.icon {
            self.showIcon = true
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
            self.showIcon = false
        }
    }
    
    // MARK: Other
    
    fileprivate let defaultError = "An error occured, please try again later"
}

extension PlaceDetailsViewModel: PlaceDetailsServiceDelegate {
    func placeDetailsServiceDidUpdate(_ service: PlaceDetailsServiceProtocol) {
        // Check that model is exists
        var showContent = false
        if let model = service.place {
            showContent = true
            self.model = model
        } else {
            self.errorText = self.defaultError
        }
        
        self.showError = !showContent
        self.showLoadingIndicator = !showContent
        self.showContentView = showContent
        
        delegate?.placeDetailsViewModelUpdated(self)
    }
    
    func placeDetailsService(_ service: PlaceDetailsServiceProtocol, didFailToUpdate error: Error) {
        // Show error and hide the other components
        self.errorText = self.defaultError
        self.showError = true
        self.showLoadingIndicator = false
        self.showContentView = false
        
        delegate?.placeDetailsViewModelUpdated(self)
    }
}
