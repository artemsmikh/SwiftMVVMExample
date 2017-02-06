//
//  PredictionSearchAPIService.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 05/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import Alamofire

class PredictionSearchAPIService: PredictionSearchService {
    let minimalSearchTextLength = 3
    
    var delegate: PredictionSearchServiceDelegate?
    
    var searchText: String = "" {
        didSet {
            // Perform a new search when value is changed
            search()
        }
    }
    
    private(set) var predictions: [PredictionModel] = []
    
    init(withConfig config: GooglePlacesConfig) {
        self.config = config
    }
    
    private var config: GooglePlacesConfig
    private var currentRequest: Request? = nil
    
    private func search() {
        // Cancel current request (if exists)
        currentRequest?.cancel()
        currentRequest = nil
        
        // Check search text length
        if searchText.characters.count >= minimalSearchTextLength {
            // Perform a search
            performSearch(completionHandler: { (result, error) in
                // Save received predictions (for both cases when the error exists or not)
                self.predictions = result
                if let error = error {
                    // If there was an error - notify delegate about it
                    self.delegate?.predictionSearchService(self, didFailToUpdatePredictions: error)
                } else {
                    // Notify delegate about successfull result
                    self.delegate?.predictionSearchServiceDidUpdatePredictions(self)
                }
            })
        } else {
            // Clear old values and notify delegate
            predictions = []
            delegate?.predictionSearchServiceDidUpdatePredictions(self)
        }
    }
    
    private func performSearch(completionHandler: @escaping (_ result: [PredictionModel], _ error: Error?) -> Void) {
        let url = prepareRequestUrl()
        let parameters = prepareRequestParameters()
        
        currentRequest = Alamofire.request(url, parameters: parameters).responseJSON { response in
            if let error = response.error {
                completionHandler([], error)
                return
            }
            
            // Check that response is a correct JSON
            guard let json = response.result.value as? [String: Any] else {
                completionHandler([], self.requestError("Invalid response"))
                return
            }
            
            let parseResults = self.parseResponse(json)
            
            if let error = parseResults.error {
                completionHandler([], error)
                return
            }
            
            completionHandler(parseResults.result, nil)
        }
    }
    
    private func parseResponse(_ response: [String: Any]) -> (result: [PredictionModel], error: Error?) {
        // Check that response has a "status" key
        guard let status = response["status"] as? String else {
            return ([], requestError("Response does not contain a status"))
        }
        
        // Check that status is ok
        if status != "OK" && status != "ZERO_RESULTS" {
            return ([], requestError("Incorrect response status"))
        }
        
        // Check that response has a "predictions" key
        guard let predictionsInfo = response["predictions"] as? [Any] else {
            return ([], requestError("Response does not contain predictions"))
        }
        
        // Parse predictions
        var result: [PredictionModel] = []
        
        for info in predictionsInfo {
            if let info = info as? [String: Any] {
                if let prediction = parsePrediction(from: info) {
                    result.append(prediction)
                }
            }
        }
        
        // Return parser predictions
        return (result, nil)
    }
    
    private func parsePrediction(from info: [String: Any]) -> PredictionModel? {
        // Check for all necessary values
        guard let id = info["id"] as? String,
              let placeId = info["place_id"] as? String,
              let placeDescription = info["description"] as? String else {
                return nil;
        }
        
        let prediction = PredictionModel(predictionId: id, placeId: placeId, placeDescription: placeDescription)
        
        // Add prediction types if there any
        if let types = info["types"] as? [String] {
            prediction.types = []
            
            for type in types {
                prediction.types?.append(type)
            }
        }
        
        // Add matches if there any
        if let matches = info["matched_substrings"] as? [Any] {
            prediction.matches = []
            
            for match in matches {
                guard let match = match as? [String: Any],
                      let length = match["length"] as? Int,
                      let offset = match["offset"] as? Int else {
                        continue
                }
                
                prediction.matches?.append((offset: offset, length: length))
            }
        }
        
        return prediction
    }
    
    private func prepareRequestUrl() -> String {
        return "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    }
    
    private func prepareRequestParameters() -> Parameters {
        return ["input": searchText, "key": config.apiKey]
    }
    
    private func requestError(_ message: String) -> Error {
        return PredictionSearchServiceError.RequestFailure(message: message)
    }
}
