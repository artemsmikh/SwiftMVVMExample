//
//  PredictionSearchAPIParser.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

class PredictionSearchAPIParser {
    static func parseResponse(_ response: [String: Any]) -> (result: [PredictionModel], error: PredictionSearchAPIError?) {
        // Check that response has a "status" key
        guard let status = response["status"] as? String else {
            return ([], PredictionSearchAPIError.WrongResponseFormat)
        }
        
        // Check that status is ok
        if status != "OK" && status != "ZERO_RESULTS" {
            return ([], PredictionSearchAPIError.IncorrectResponseStatus)
        }
        
        // Check that response has a "predictions" key
        guard let predictionsInfo = response["predictions"] as? [Any] else {
            return ([], PredictionSearchAPIError.WrongResponseFormat)
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
    
    static func parsePrediction(from info: [String: Any]) -> PredictionModel? {
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
}
