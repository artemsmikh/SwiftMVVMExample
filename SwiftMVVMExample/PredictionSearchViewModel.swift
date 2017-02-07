//
//  PredictionSearchViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

class PredictionSearchViewModel: PredictionSearchViewModelProtocol {
    var delegate: PredictionSearchViewModelDelegate?
    
    var searchText: String {
        get {
            return searchService.searchText
        }
        set(newValue) {
            searchService.searchText = newValue
        }
    }
    
    var searchPlaceholderText: String {
        return "Search Google Places"
    }
    
    var displayTooltip: Bool = false
    var tooltipText: String = ""
    
    var cells: [PredictionCellViewModelProtocol] = [] {
        didSet {
            delegate?.predictionSearchViewModelDidUpdatePredictions(self)
        }
    }
    
    fileprivate var searchService: PredictionSearchService
    
    init(withSearchService service: PredictionSearchService) {
        searchService = service
        searchService.delegate = self
    }
    
    fileprivate func showTooltip(withText text: String) {
        tooltipText = text
        displayTooltip = true
        delegate?.predictionSearchViewModelDidUpdateTooltip(self)
    }
    
    fileprivate func hideTooltip() {
        tooltipText = ""
        displayTooltip = false
        delegate?.predictionSearchViewModelDidUpdateTooltip(self)
    }
}

extension PredictionSearchViewModel: PredictionSearchServiceDelegate {
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchService) {
        var updatedCells: [PredictionCellViewModelProtocol] = []
        for prediction in searchService.predictions {
            updatedCells.append(PredictionCellViewModel(withPrediction: prediction))
        }
        self.cells = updatedCells
        
        if service.status == .NoResults {
            showTooltip(withText: "We could not find this place")
        } else if displayTooltip {
            hideTooltip()
        }
    }
    
    func predictionSearchService(_ service: PredictionSearchService, didFailToUpdatePredictions error: Error) {
        self.cells = []
        showTooltip(withText: "An error occured, please try again later")
    }
}
