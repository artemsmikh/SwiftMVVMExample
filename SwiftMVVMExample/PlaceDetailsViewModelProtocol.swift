//
//  PlaceDetailsViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

protocol PlaceDetailsViewModelProtocol {
    var delegate: PlaceDetailsViewModelDelegate? { get set }
    
    var titleText: String? { get }
    
    var showLoadingIndicator: Bool { get }
    
    var showError: Bool { get }
    var errorText: String? { get }
    
    var showContentView: Bool { get }
    var nameText: String? { get }
    var ratingText: String? { get }
    var addressText: NSAttributedString? { get }
    var phoneText: NSAttributedString? { get }
    var websiteText: NSAttributedString? { get }
    
    var showIcon: Bool { get }
    var icon: UIImage? { get }
    
    func loadDetails()
}

protocol PlaceDetailsViewModelDelegate {
    func viewModelDidUpdateLoadingIndicatorVisibility()
    
    func viewModelDidUpdateContentViewVisibility()
    
    func viewModelDidUpdateErrorVisibility()
    func viewModelDidUpdateErrorText()
    
    func viewModelDidUpdateIconVisibility()
    func viewModelDidUpdateIconImage()
    
    func viewModelDidUpdateName()
    func viewModelDidUpdateRating()
    func viewModelDidUpdateAddress()
    func viewModelDidUpdatePhone()
    func viewModelDidUpdateWebsite()
}
