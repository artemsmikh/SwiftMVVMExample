//
//  PredictionSearchViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

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
    
    fileprivate var searchService: PredictionSearchServiceProtocol
    
    init(withSearchService service: PredictionSearchServiceProtocol) {
        searchService = service
        searchService.delegate = self
        
        if searchTextIsEmpty() {
            showEmptySearchTextTooltip()
        }
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
    
    fileprivate func searchTextIsEmpty() -> Bool {
        return searchService.searchText.characters.count == 0
    }
    
    fileprivate func showEmptySearchTextTooltip() {
        showTooltip(withText: "Start typing a place name and the suggestions will appear here!")
    }
    
    
    // MARK: Actions from delegate
    
    func onSelectCell(withIndex index: Int) {
        let model = self.searchService.predictions[index]
        let placeId = model.placeId
        
        // Create a ViewModel for passing to place details screen
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let placeDetailsViewModel = appDelegate.preparePlaceDetailsViewModel(forPlaceId: placeId)
        
        // Tell delegate to show place details with the created VM
        self.delegate?.predictionSearchViewModel(self, showPlaceDetails: placeDetailsViewModel)
    }
}

extension PredictionSearchViewModel: PredictionSearchServiceDelegate {
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchServiceProtocol) {
        var updatedCells: [PredictionCellViewModelProtocol] = []
        for prediction in searchService.predictions {
            updatedCells.append(PredictionCellViewModel(withPrediction: prediction))
        }
        self.cells = updatedCells
        
        if service.status == .NoResults {
            showTooltip(withText: "We could not find this place")
        } else if service.status == .ShortInput && searchTextIsEmpty() {
            showEmptySearchTextTooltip()
        } else if displayTooltip {
            hideTooltip()
        }
    }
    
    func predictionSearchService(_ service: PredictionSearchServiceProtocol, didFailToUpdatePredictions error: Error) {
        self.cells = []
        
        // Don't inform view about -999 (Cancelled) error
        if (error as NSError).code == NSURLErrorCancelled {
            return
        }
        
        showTooltip(withText: "An error occured, please try again later")
    }
}
