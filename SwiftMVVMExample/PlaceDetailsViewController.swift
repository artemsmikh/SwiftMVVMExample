//
//  PlaceDetailsViewController.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var iconActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var viewModel: PlaceDetailsViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel!.titleText
        
        viewModel!.loadDetails()
        
        updateActivityIndicator()
        updateContentView()
        updateErrorLabel()
    }
    
    
    // MARK: Updating UI
    
    fileprivate func updateActivityIndicator() {
        activityIndicator.isHidden = !viewModel!.showLoadingIndicator
    }
    
    fileprivate func updateContentView() {
        self.contentView.isHidden = !viewModel!.showContentView
    }
    
    fileprivate func updateErrorLabel() {
        self.errorLabel.isHidden = !viewModel!.showError
        self.errorLabel.text = viewModel!.errorText
    }
    
    fileprivate func updateNameLabel() {
        self.nameLabel.text = viewModel!.nameText
    }
    
    fileprivate func updateRatingLabel() {
        self.ratingLabel.text = viewModel!.ratingText
    }
    
    fileprivate func updateAddressLabel() {
        self.addressLabel.attributedText = viewModel!.addressText
    }
    
    fileprivate func updatePhoneLabel() {
        self.phoneLabel.attributedText = viewModel!.phoneText
    }
    
    fileprivate func updateWebsiteLabel() {
        self.websiteLabel.attributedText = viewModel!.websiteText
    }
    
    fileprivate func updateIcon() {
        let showActivityIndicator = viewModel!.showIcon && viewModel!.icon == nil
        let showImage = viewModel!.showIcon && viewModel!.icon != nil
        
        self.iconImageView.isHidden = !showImage
        self.iconActivityIndicator.isHidden = !showActivityIndicator
        
        if showImage {
            self.iconImageView.image = viewModel!.icon
        }
    }
}

extension PlaceDetailsViewController: PlaceDetailsViewModelDelegate {
    
    func viewModelDidUpdateLoadingIndicatorVisibility() {
        updateActivityIndicator()
    }
    
    func viewModelDidUpdateContentViewVisibility() {
        updateContentView()
    }
    
    func viewModelDidUpdateErrorVisibility() {
        updateErrorLabel()
    }
    
    func viewModelDidUpdateErrorText() {
        updateErrorLabel()
    }
    
    func viewModelDidUpdateIconVisibility() {
        updateIcon()
    }
    
    func viewModelDidUpdateIconImage() {
        updateIcon()
    }
    
    func viewModelDidUpdateName() {
        updateNameLabel()
    }
    
    func viewModelDidUpdateRating() {
        updateRatingLabel()
    }
    
    func viewModelDidUpdateAddress() {
        updateAddressLabel()
    }
    
    func viewModelDidUpdatePhone() {
        updatePhoneLabel()
    }
    
    func viewModelDidUpdateWebsite() {
        updateWebsiteLabel()
    }
}
