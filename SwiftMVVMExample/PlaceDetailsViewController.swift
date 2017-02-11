//
//  PlaceDetailsViewController.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 11/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    var viewModel: PlaceDetailsViewModelProtocol? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    // MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel?.title
    }

}

extension PlaceDetailsViewController: PlaceDetailsViewModelDelegate {
    func placeDetailsViewModelDidUpdateName(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
    
    func placeDetailsViewModelDidUpdatePhone(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
    
    func placeDetailsViewModelDidUpdateRating(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
    
    func placeDetailsViewModelDidUpdateAddress(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
    
    func placeDetailsViewModelDidStartLoadingIcon(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
    
    func placeDetailsViewModelDidFinishLoadingIcon(_ viewModel: PlaceDetailsViewModelProtocol) {
        // TODO:
    }
}
