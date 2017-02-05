//
//  PredictionSearchServiceAPI.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 03/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import Alamofire

class PredictionSearchServiceAPI: PredictionSearchService {
    let minimalSearchTextLength = 3
    
    var delegate: PredictionSearchServiceDelegate?
    
    var searchText: String = "" {
        didSet {
            // Perform a new search when value is changed
            search()
        }
    }
    
    private(set) var predictions: [PredictionModel] = []
    
    private var currentRequest: Request?
    
    private func search() {
        // Cancel previous request
        currentRequest?.cancel()
        currentRequest = nil
        
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
        // TODO: Perform a real search
        var fakePredictions: [PredictionModel] = []
        var fake = PredictionModel(predictionId: "1", placeId: "1", placeDescription: "Prediction 1")
        fakePredictions.append(fake)
        fake = PredictionModel(predictionId: "2", placeId: "2", placeDescription: "Prediction 2")
        fakePredictions.append(fake)
        fake = PredictionModel(predictionId: "3", placeId: "3", placeDescription: "Prediction 3")
        fakePredictions.append(fake)
        completionHandler(fakePredictions, nil)
    }
}
