//
//  PlaceDetailsViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import UIKit

protocol PlaceDetailsViewModelProtocol {
    var delegate: PlaceDetailsViewModelDelegate? { get set }
    
    var title: String? { get }
    var name: String? { get }
    var rating: String? { get }
    var address: String? { get }
    var phone: String? { get }
    var website: String? { get }
    var icon: UIImage? { get }
}

protocol PlaceDetailsViewModelDelegate {
    func placeDetailsViewModelDidUpdateName(_ viewModel: PlaceDetailsViewModelProtocol)
    func placeDetailsViewModelDidUpdateRating(_ viewModel: PlaceDetailsViewModelProtocol)
    func placeDetailsViewModelDidUpdateAddress(_ viewModel: PlaceDetailsViewModelProtocol)
    func placeDetailsViewModelDidUpdatePhone(_ viewModel: PlaceDetailsViewModelProtocol)
    func placeDetailsViewModelDidStartLoadingIcon(_ viewModel: PlaceDetailsViewModelProtocol)
    func placeDetailsViewModelDidFinishLoadingIcon(_ viewModel: PlaceDetailsViewModelProtocol)
}
