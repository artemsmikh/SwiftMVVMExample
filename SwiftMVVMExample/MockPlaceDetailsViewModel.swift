//
//  MockPlaceDetailsViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import UIKit

class  MockPlaceDetailsViewModel: PlaceDetailsViewModelProtocol {
    var delegate: PlaceDetailsViewModelDelegate?
    
    var title: String? = "Place Details"
    var name: String?
    var rating: String?
    var address: String?
    var phone: String?
    var website: String?
    var icon: UIImage?
}
