//
//  PlaceDetailsPhotoCell.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 15/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PlaceDetailsPhotoCell: UICollectionViewCell {
    let fadeAnimationDuration: TimeInterval = 0.3
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configure(_ viewModel: inout PlacePhotoViewModelProtocol) {
        if let image = viewModel.image {
            imageView.image = image
        } else {
            activityIndicator.isHidden = false
            viewModel.delegate = self
            viewModel.loadImage()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        activityIndicator.alpha = 1
        imageView.image = nil
        imageView.alpha = 1
    }
}


// MARK: PlacePhotoViewModelDelegate
extension PlaceDetailsPhotoCell: PlacePhotoViewModelDelegate {
    func placePhotoViewModelImageLoaded(_ viewModel: PlacePhotoViewModelProtocol) {
        // Animate image appearing
        if let image = viewModel.image {
            imageView.image = image
        }
        imageView.alpha = 0
        activityIndicator.alpha = 1
        UIView.animate(withDuration: fadeAnimationDuration, animations: { 
            self.imageView.alpha = 1
            self.activityIndicator.alpha = 0
        }) { (_) in
            self.activityIndicator.isHidden = true
        }
    }
    
    func placePhotoViewModelImageLoadingError(_ viewModel: PlacePhotoViewModelProtocol, error: Error) {
        activityIndicator.stopAnimating()
        print("Error while loading photo: \(error)")
    }
}
