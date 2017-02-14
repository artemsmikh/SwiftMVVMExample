//
//  PlacePhotoViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 14/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

protocol PlacePhotoViewModelProtocol {
    weak var delegate: PlacePhotoViewModelDelegate? { set get }
    
    var photoUrl: URL { get }
    var image: UIImage? { get }
    
    func loadImage()
}

protocol PlacePhotoViewModelDelegate: class {
    func placePhotoViewModelImageLoaded(_ viewModel: PlacePhotoViewModelProtocol)
    func placePhotoViewModelImageLoadingError(_ viewModel: PlacePhotoViewModelProtocol, error: Error)
}
