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
        
        self.service.loadDetails()
    }
    
    var titleText: String? {
        return "Place Details"
    }
    
    fileprivate(set) var showLoadingIndicator: Bool = false {
        didSet {
            delegate?.viewModelDidUpdateLoadingIndicatorVisibility()
        }
    }
    
    fileprivate(set) var errorText: String? {
        didSet {
            delegate?.viewModelDidUpdateErrorText()
        }
    }
    
    fileprivate(set) var showError: Bool = false {
        didSet {
            delegate?.viewModelDidUpdateErrorVisibility()
        }
    }
    
    fileprivate(set) var showContentView: Bool = false {
        didSet {
            delegate?.viewModelDidUpdateContentViewVisibility()
        }
    }
    
    fileprivate(set) var nameText: String? {
        didSet {
            delegate?.viewModelDidUpdateName()
        }
    }
    
    fileprivate(set) var ratingText: String? {
        didSet {
            delegate?.viewModelDidUpdateRating()
        }
    }
    
    fileprivate(set) var addressText: NSAttributedString? {
        didSet {
            delegate?.viewModelDidUpdateAddress()
        }
    }
    
    fileprivate(set) var phoneText: NSAttributedString? {
        didSet {
            delegate?.viewModelDidUpdatePhone()
        }
    }
    
    fileprivate(set) var websiteText: NSAttributedString? {
        didSet {
            delegate?.viewModelDidUpdateWebsite()
        }
    }
    
    fileprivate(set) var showIcon: Bool = false {
        didSet {
            delegate?.viewModelDidUpdateIconVisibility()
        }
    }
    
    fileprivate(set) var icon: UIImage? {
        didSet {
            delegate?.viewModelDidUpdateIconImage()
        }
    }
    
    
    // MARK: Update model
    
    private func updateViewModel() {
        guard let model = self.model else {
            return
        }
        // TODO: Check for URL
        
        self.nameText = model.name
        
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
    }
    
    func placeDetailsService(_ service: PlaceDetailsServiceProtocol, didFailToUpdate error: Error) {
        // Show error and hide the other components
        self.errorText = self.defaultError
        self.showError = true
        self.showLoadingIndicator = false
        self.showContentView = false
    }
}
