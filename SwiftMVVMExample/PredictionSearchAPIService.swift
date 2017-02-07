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
    
    private(set) var status: PredictionSearchServiceStatus = .ShortInput
    
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
            status = .Loading
            performSearch(completionHandler: { (result, error) in
                // Save received predictions (for both cases when the error exists or not)
                self.predictions = result
                if let error = error {
                    // In case of an error we set the 'HasResults' status to distinguish it
                    // from the case when there wasn't any error and results are really empty
                    self.status = .HasResults
                    // If there was an error - notify delegate about it
                    self.delegate?.predictionSearchService(self, didFailToUpdatePredictions: error)
                } else {
                    self.status = self.predictions.count > 0 ? .HasResults : .NoResults
                    // Notify delegate about successfull result
                    self.delegate?.predictionSearchServiceDidUpdatePredictions(self)
                }
            })
        } else {
            // Clear old values and notify delegate
            status = .ShortInput
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
                completionHandler([], PredictionSearchAPIError.InvalidResponse)
                return
            }
            
            // Parse JSON response
            let parseResults = PredictionSearchAPIParser.parseResponse(json)
            
            if let error = parseResults.error {
                completionHandler([], error)
                return
            }
            
            completionHandler(parseResults.result, nil)
        }
    }
    
    private func prepareRequestUrl() -> String {
        return "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    }
    
    private func prepareRequestParameters() -> Parameters {
        return ["input": searchText, "key": config.apiKey]
    }
}
