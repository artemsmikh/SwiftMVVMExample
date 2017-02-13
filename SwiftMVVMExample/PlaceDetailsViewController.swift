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
        
        updateView()
        
        viewModel!.loadDetails()
    }
    
    
    // MARK: Updating UI
    
    fileprivate func updateView() {
        self.title = viewModel!.titleText
        
        activityIndicator.isHidden = !viewModel!.showLoadingIndicator
        
        errorLabel.isHidden = !viewModel!.showError
        errorLabel.text = viewModel!.errorText
        
        contentView.isHidden = !viewModel!.showContentView
        
        nameLabel.text = viewModel!.nameText
        ratingLabel.text = viewModel!.ratingText
        addressLabel.attributedText = viewModel!.addressText
        phoneLabel.attributedText = viewModel!.phoneText
        websiteLabel.attributedText = viewModel!.websiteText
        
        let showIconActivityIndicator = viewModel!.showIcon && viewModel!.icon == nil
        let showIcon = viewModel!.showIcon && viewModel!.icon != nil
        
        self.iconActivityIndicator.isHidden = !showIconActivityIndicator
        self.iconImageView.isHidden = !showIcon
        
        if showIcon {
            self.iconImageView.image = viewModel!.icon
        }
    }
}

extension PlaceDetailsViewController: PlaceDetailsViewModelDelegate {
    
    func placeDetailsViewModelUpdated(_ viewModel: PlaceDetailsViewModelProtocol) {
        updateView()
    }
}
