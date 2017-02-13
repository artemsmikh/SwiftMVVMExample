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
    
    private var addressTapRecognizer: UITapGestureRecognizer?
    private var phoneTapRecognizer: UITapGestureRecognizer?
    private var websiteTapRecognizer: UITapGestureRecognizer?
    
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
        
        updateAddress()
        updatePhone()
        updateWebsite()
        
        let showIconActivityIndicator = viewModel!.showIcon && viewModel!.icon == nil
        let showIcon = viewModel!.showIcon && viewModel!.icon != nil
        
        self.iconActivityIndicator.isHidden = !showIconActivityIndicator
        self.iconImageView.isHidden = !showIcon
        
        if showIcon {
            self.iconImageView.image = viewModel!.icon
        }
    }
    
    private func updateAddress() {
        addressLabel.attributedText = viewModel!.addressText
        
        if viewModel!.shouldProccessAddressClicks {
            if addressTapRecognizer == nil {
                addressTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onAddressClicked(_:)))
                addressLabel.addGestureRecognizer(addressTapRecognizer!)
                addressLabel.isUserInteractionEnabled = true
            }
        } else {
            if let recognizer = addressTapRecognizer {
                addressLabel.removeGestureRecognizer(recognizer)
                addressTapRecognizer = nil
            }
        }
    }
    
    private func updatePhone() {
        phoneLabel.attributedText = viewModel!.phoneText
        
        if viewModel!.shouldProccessPhoneClicks {
            if phoneTapRecognizer == nil {
                phoneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onPhoneClicked(_:)))
                phoneLabel.addGestureRecognizer(phoneTapRecognizer!)
                phoneLabel.isUserInteractionEnabled = true
            }
        } else {
            if let recognizer = phoneTapRecognizer {
                phoneLabel.removeGestureRecognizer(recognizer)
                phoneTapRecognizer = nil
            }
        }
    }
    
    private func updateWebsite() {
        websiteLabel.attributedText = viewModel!.websiteText
        
        if viewModel!.shouldProccessWebsiteClicks {
            if websiteTapRecognizer == nil {
                websiteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onWebsiteClicked(_:)))
                websiteLabel.addGestureRecognizer(websiteTapRecognizer!)
                websiteLabel.isUserInteractionEnabled = true
            }
        } else {
            if let recognizer = websiteTapRecognizer {
                websiteLabel.removeGestureRecognizer(recognizer)
                websiteTapRecognizer = nil
            }
        }
    }
    
    
    // MARK: Actions
    
    @objc private func onAddressClicked(_ sender: UITapGestureRecognizer) {
        viewModel?.onAddressClicked()
    }
    
    @objc private func onPhoneClicked(_ sender: UITapGestureRecognizer) {
        viewModel?.onPhoneClicked()
    }
    
    @objc private func onWebsiteClicked(_ sender: UITapGestureRecognizer) {
        viewModel?.onWebsiteClicked()
    }
}

extension PlaceDetailsViewController: PlaceDetailsViewModelDelegate {
    
    func placeDetailsViewModelUpdated(_ viewModel: PlaceDetailsViewModelProtocol) {
        updateView()
    }
    
    func shouldOpenLink(link: URL, from viewModel: PlaceDetailsViewModelProtocol) {
        if (UIApplication.shared.canOpenURL(link)) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
}
