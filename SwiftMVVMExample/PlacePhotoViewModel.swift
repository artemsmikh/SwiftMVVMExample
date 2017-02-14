//
//  PlacePhotoViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 14/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PlacePhotoViewModel: PlacePhotoViewModelProtocol {
    weak var delegate: PlacePhotoViewModelDelegate?
    
    private(set) var photoUrl: URL
    private(set) var image: UIImage?
    
    init(with photoUrl: URL) {
        self.photoUrl = photoUrl
    }
    
    
    func loadImage() {
        URLSession.shared.dataTask(with: photoUrl, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.placePhotoViewModelImageLoadingError(self, error: error!)
                    }
                }
                return
            }
            
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
                self.delegate?.placePhotoViewModelImageLoaded(self)
            }
        }).resume()
    }
}
