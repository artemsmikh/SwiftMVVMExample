//
//  PredictionSearchMockService.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 03/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

class PredictionSearchMockService: PredictionSearchService {
    let minimalSearchTextLength = 3
    
    var delegate: PredictionSearchServiceDelegate?
    
    var searchText: String = "" {
        didSet {
            // Perform a new search when value is changed
            search()
        }
    }
    
    private(set) var predictions: [PredictionModel] = []
    
    private func search() {
        // Check search text length
        if searchText.characters.count >= minimalSearchTextLength {
            // Perform a search
            performSearch(completionHandler: { (result, error) in
                // Save received predictions (for both cases when the error exists or not)
                predictions = result
                if let error = error {
                    // If there was an error - notify delegate about it
                    delegate?.predictionSearchService(self, didFailToUpdatePredictions: error)
                } else {
                    // Notify delegate about successfull result
                    delegate?.predictionSearchServiceDidUpdatePredictions(self)
                }
            })
        } else {
            // Clear old values and notify delegate
            predictions = []
            delegate?.predictionSearchServiceDidUpdatePredictions(self)
        }
    }
    
    private func performSearch(completionHandler: (_ result: [PredictionModel], _ error: Error?) -> Void) {
        // Mock results
        var fakePredictions: [PredictionModel] = []
        for i in 1..<10 {
            let fake = PredictionModel(predictionId: "\(i)", placeId: "\(i)", placeDescription: "Prediction \(i)")
            fakePredictions.append(fake)
        }
        completionHandler(fakePredictions, nil)
    }
}
