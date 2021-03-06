//
//  PredictionSearchViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

final class PredictionSearchViewModel: PredictionSearchViewModelProtocol {
    
    fileprivate var searchService: PredictionSearchServiceProtocol
    
    init(withSearchService service: PredictionSearchServiceProtocol) {
        searchService = service
        searchService.delegate = self
        
        if searchTextIsEmpty() {
            showEmptySearchTextTooltip()
        }
    }
    

    // MARK: Protocol properties
    
    weak var delegate: PredictionSearchViewModelDelegate?
    
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
    var tooltipText: String = ""
    
    var displayTooltip: Bool = false
    var displayTable: Bool = false
    var displayLoadingIndicator: Bool = false {
        didSet {
            delegate?.predictionSearchViewModelDidUpdateLoadingIndicator(self)
        }
    }
    
    var cells: [PredictionCellViewModelProtocol] = [] {
        didSet {
            displayTable = cells.count > 0
            delegate?.predictionSearchViewModelDidUpdatePredictions(self)
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
    
    
    // MARK: Protocol functions
    func onSelectCell(withIndex index: Int) {
        let model = searchService.predictions[index]
        let placeId = model.placeId
        
        // Create a ViewModel for passing to place details screen
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let placeDetailsViewModel = appDelegate.preparePlaceDetailsViewModel(forPlaceId: placeId)
        
        // Tell delegate to show place details with the created VM
        delegate?.predictionSearchViewModel(self, showPlaceDetails: placeDetailsViewModel)
    }
}


// MARK: PredictionSearchServiceDelegate
extension PredictionSearchViewModel: PredictionSearchServiceDelegate {
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchServiceProtocol) {
        var updatedCells: [PredictionCellViewModelProtocol] = []
        for prediction in searchService.predictions {
            updatedCells.append(PredictionCellViewModel(withPrediction: prediction))
        }
        cells = updatedCells
    }
    
    func predictionSearchService(_ service: PredictionSearchServiceProtocol, didFailToUpdatePredictions error: Error) {
        cells = []
    }
    
    func predictionSearchServiceDidUpdateStatus(_ service: PredictionSearchServiceProtocol) {
        // Update tooltip
        if service.status == .ShortInput {
            showEmptySearchTextTooltip()
        } else if service.status == .NoResults {
            showTooltip(withText: "We could not find this place")
        } else if service.status == .Error {
            showTooltip(withText: "An error occured, please try again later")
        } else if service.status == .Loading || service.status == .HasResults {
            hideTooltip()
        }
        
        // Update loading indicator
        displayLoadingIndicator = service.status == .Loading && cells.count == 0
    }
}
