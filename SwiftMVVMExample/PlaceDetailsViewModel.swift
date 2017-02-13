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
    
    var titleText: String? {
        return "Place Details"
    }
    
    fileprivate(set) var showLoadingIndicator: Bool = false
    
    fileprivate(set) var errorText: String?
    fileprivate(set) var showError: Bool = false
    
    fileprivate(set) var showContentView: Bool = false
    fileprivate(set) var nameText: String?
    fileprivate(set) var ratingText: String?
    fileprivate(set) var addressText: NSAttributedString?
    fileprivate(set) var phoneText: NSAttributedString?
    fileprivate(set) var websiteText: NSAttributedString?
    fileprivate(set) var showIcon: Bool = false
    fileprivate(set) var icon: UIImage?
    
    // MARK: Update model
    
    private func updateViewModel() {
        guard let model = self.model else {
            return
        }
        // TODO: Check for URL
        
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
            self.addressText = NSAttributedString(string: address)
        } else {
            self.addressText = NSAttributedString(string: "No address specified")
        }
    }
    
    private func updatePhone() {
        if let phone = model?.phone {
            self.phoneText = NSAttributedString(string: phone)
        } else {
            self.phoneText = NSAttributedString(string: "No phone specified")
        }
    }
    
    private func updateWebsite() {
        if let url = model?.website {
            self.websiteText = NSAttributedString(string: url.absoluteString)
        } else {
            self.websiteText = NSAttributedString(string: "No website specified")
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
