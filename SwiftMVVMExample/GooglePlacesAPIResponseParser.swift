//
//  GooglePlacesAPIResponseParser.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 08/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import Alamofire

class GooglePlacesAPIResponseParser {
    
    static func parseResponse(_ response: Alamofire.DataResponse<Any>) -> (json: [String: Any]?, error: Error?) {
        if let error = response.error {
            return (nil, error)
        }
        
        // Check that response is a correct JSON
        guard let json = response.result.value as? [String: Any] else {
            return (nil, GooglePlacesAPIResponseError.InvalidResponse)
        }
        
        // Parse JSON response
        if let error = checkJsonResponseForErrors(json) {
            return (nil, error)
        }
        
        // Return correct json
        return (json, nil)
    }
    
    private static func checkJsonResponseForErrors(_ response: [String: Any]) -> GooglePlacesAPIResponseError? {
        // Check that response has a "status" key
        guard let status = response["status"] as? String else {
            return GooglePlacesAPIResponseError.WrongResponseFormat
        }
        
        // Check that status is ok
        if status != "OK" && status != "ZERO_RESULTS" {
            return GooglePlacesAPIResponseError.IncorrectResponseStatus
        }
        
        return nil
    }
}
