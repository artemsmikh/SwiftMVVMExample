//
//  PlaceDetailsViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

protocol PlaceDetailsViewModelProtocol {
    weak var delegate: PlaceDetailsViewModelDelegate? { get set }
        
    var showLoadingIndicator: Bool { get }
    var showError: Bool { get }
    var showContentView: Bool { get }
    
    var titleText: String? { get }
    var errorText: String? { get }
    var nameText: String? { get }
    var ratingText: String? { get }
    
    var shouldProccessAddressClicks: Bool { get }
    var addressText: NSAttributedString? { get }
    
    var shouldProccessPhoneClicks: Bool { get }
    var phoneText: NSAttributedString? { get }
    
    var shouldProccessWebsiteClicks: Bool { get }
    var websiteText: NSAttributedString? { get }
    
    var showIcon: Bool { get }
    var icon: UIImage? { get }
    
    var photos: [PlacePhotoViewModelProtocol] { get }
    
    func loadDetails()
    
    func onAddressClicked()
    func onPhoneClicked()
    func onWebsiteClicked()
}

protocol PlaceDetailsViewModelDelegate: class {
    func placeDetailsViewModelUpdated(_ viewModel: PlaceDetailsViewModelProtocol)
    func shouldOpenLink(link: URL, from viewModel: PlaceDetailsViewModelProtocol)
}
