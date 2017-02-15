//
//  PlaceDetailsViewController.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

final class PlaceDetailsViewController: UIViewController {
    
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
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    @IBOutlet weak var constraintPhotosZeroHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintPhoneZeroHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintWebsiteZeroHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintAddressZeroHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintRatingBottom: NSLayoutConstraint!
    
    let photoCellIdentifier = "photoCell"
    let iconBackgroundCornerRadius: CGFloat = 7
    
    private var addressTapRecognizer: UITapGestureRecognizer?
    private var phoneTapRecognizer: UITapGestureRecognizer?
    private var websiteTapRecognizer: UITapGestureRecognizer?
    private var iconTapRecognizer: UITapGestureRecognizer?
    
    var viewModel: PlaceDetailsViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        updateView()
        
        viewModel!.loadDetails()
    }
    
    
    // MARK: Updating UI
    
    fileprivate func updateView() {
        title = viewModel!.titleText
        
        activityIndicator.isHidden = !viewModel!.showLoadingIndicator
        
        errorLabel.isHidden = !viewModel!.showError
        errorLabel.text = viewModel!.errorText
        
        contentView.isHidden = !viewModel!.showContentView
        
        nameLabel.text = viewModel!.nameText
        
        updateRating()
        updatePhotos()
        updateAddress()
        updatePhone()
        updateWebsite()
        
        let showIconActivityIndicator = viewModel!.showIcon && viewModel!.icon == nil
        let showIcon = viewModel!.showIcon && viewModel!.icon != nil
        
        iconActivityIndicator.isHidden = !showIconActivityIndicator
        iconImageView.isHidden = !showIcon
        iconBackgroundView.isHidden = iconImageView.isHidden
        // Round icon background corners
        iconBackgroundView.layer.cornerRadius = iconBackgroundCornerRadius
        
        if showIcon {
            iconImageView.image = viewModel!.icon
            
            // Add tap gesture recognizer to icon (show map on click)
            if iconTapRecognizer == nil {
                iconTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAddressClicked(_:)))
                iconImageView.addGestureRecognizer(iconTapRecognizer!)
            }
        }
    }
    
    private func updateRating() {
        guard let ratingText = viewModel!.ratingText else {
            constraintRatingBottom.priority = UILayoutPriorityDefaultLow
            ratingLabel.isHidden = true
            return
        }
        constraintRatingBottom.priority = UILayoutPriorityDefaultHigh
        ratingLabel.isHidden = false
        
        ratingLabel.text = ratingText
    }
    
    private func updatePhotos() {
        guard viewModel!.photos.count > 0 else {
            constraintPhotosZeroHeight.priority = UILayoutPriorityDefaultHigh
            photosCollectionView.isHidden = true
            return
        }
        constraintPhotosZeroHeight.priority = UILayoutPriorityDefaultLow
        photosCollectionView.isHidden = false
        
        photosCollectionView.reloadData()
    }
    
    private func updateAddress() {
        guard let addressText = viewModel!.addressText else {
            constraintAddressZeroHeight.priority = UILayoutPriorityDefaultHigh
            addressView.isHidden = true
            return
        }
        constraintAddressZeroHeight.priority = UILayoutPriorityDefaultLow
        addressView.isHidden = false
        
        addressLabel.attributedText = addressText
        
        if viewModel!.shouldProccessAddressClicks {
            if addressTapRecognizer == nil {
                addressTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onAddressClicked(_:)))
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
        guard let phoneText = viewModel!.phoneText else {
            constraintPhoneZeroHeight.priority = UILayoutPriorityDefaultHigh
            phoneView.isHidden = true
            return
        }
        constraintPhoneZeroHeight.priority = UILayoutPriorityDefaultLow
        phoneView.isHidden = false
        
        phoneLabel.attributedText = phoneText
        
        if viewModel!.shouldProccessPhoneClicks {
            if phoneTapRecognizer == nil {
                phoneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onPhoneClicked(_:)))
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
        guard let websiteText = viewModel!.websiteText else {
            constraintWebsiteZeroHeight.priority = UILayoutPriorityDefaultHigh
            websiteView.isHidden = true
            return
        }
        constraintWebsiteZeroHeight.priority = UILayoutPriorityDefaultLow
        websiteView.isHidden = false
        
        websiteLabel.attributedText = websiteText
        
        if viewModel!.shouldProccessWebsiteClicks {
            if websiteTapRecognizer == nil {
                websiteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onWebsiteClicked(_:)))
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


// MARK: PlaceDetailsViewModelDelegate
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


// MARK: UICollectionViewDelegateFlowLayout
extension PlaceDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}


// MARK: UICollectionViewDataSource
extension PlaceDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PlaceDetailsPhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier, for: indexPath) as! PlaceDetailsPhotoCell
        
        var photoViewModel = viewModel!.photos[indexPath.row]
        photoViewModel.delegate = nil
        cell.configure(&photoViewModel)
        
        return cell
    }
}
