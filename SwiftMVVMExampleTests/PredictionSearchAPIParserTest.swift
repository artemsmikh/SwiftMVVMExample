//
//  PredictionSearchAPIParserTest.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import XCTest

final class PredictionSearchAPIParserTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWrongResponseFormat() {
        var json: [String: Any]
        var results: (result: [PredictionModel], error: Error?)
        
        // Empty response
        json = [:]
        results = PredictionSearchAPIParser.parseResponse(json)
        XCTAssertNotNil(results.error)
        XCTAssertEqual(results.result.count, 0)
        
        // Response without 'status' field
        // TODO: Write tests for GooglePlacesResponseParser
//        json = ["predictions": []]
//        results = PredictionSearchAPIParser.parseResponse(json)
//        XCTAssertNotNil(results.error)
//        XCTAssertEqual(results.result.count, 0)
        
        // Response without 'predictions' field
        json = ["status": "OK"]
        results = PredictionSearchAPIParser.parseResponse(json)
        XCTAssertNotNil(results.error)
        XCTAssertEqual(results.result.count, 0)
    }
    
    func testResponseStatus() {
        var json: [String: Any]
        var results: (result: [PredictionModel], error: Error?)
        
        // TODO: Write tests for GooglePlacesResponseParser
        // Response with wrong statuses
//        json = ["status": "REQUEST_DENIED", "predictions": []]
//        results = PredictionSearchAPIParser.parseResponse(json)
//        XCTAssertNotNil(results.error)
//        XCTAssertEqual(results.result.count, 0)
//        
//        json = ["status": "INVALID_REQUEST", "predictions": []]
//        results = PredictionSearchAPIParser.parseResponse(json)
//        XCTAssertNotNil(results.error)
//        XCTAssertEqual(results.result.count, 0)
//        
//        json = ["status": "OVER_QUERY_LIMIT", "predictions": []]
//        results = PredictionSearchAPIParser.parseResponse(json)
//        XCTAssertNotNil(results.error)
//        XCTAssertEqual(results.result.count, 0)
        
        // Response with correct statuses
        json = ["status": "OK", "predictions": []]
        results = PredictionSearchAPIParser.parseResponse(json)
        XCTAssertNil(results.error)
        XCTAssertEqual(results.result.count, 0)
        
        json = ["status": "ZERO_RESULTS", "predictions": []]
        results = PredictionSearchAPIParser.parseResponse(json)
        XCTAssertNil(results.error)
        XCTAssertEqual(results.result.count, 0)
    }
    
    func testParsingPredictions() {
        var json: [String: Any]
        var results: (result: [PredictionModel], error: Error?)
        
        var allPredictions: [[String: Any]] = []
        var correctPredictions: [[String: Any]] = []
        
        // Prediction with minimum necessary fields
        allPredictions.append([
            "id": "691b237b0322f28988f3ce03e321ff72a12167fd",
            "place_id": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
            "description": "Paris, France"
        ])
        correctPredictions.append(allPredictions.last!)
        
        // Predictions with a lack of necessary fields (should be skipped)
        allPredictions.append([
            "id": "691b237b0322f28988f3ce03e321ff72a12167fd"
        ])
        allPredictions.append([
            "description": "Paris Gare de Lyon, Place Louis-Armand, Paris, France"
        ])
        allPredictions.append([
            "id": "691b237b0322f28988f3ce03e321ff72a12167fd",
            "place_id": "ChIJS78AIBty5kcRZLsIMcKhPAA"
        ])
        
        // Prediction with types
        allPredictions.append([
            "id": "691b237b0322f28988f3ce03e321ff72a12167fd",
            "place_id": "ChIJD7fiBh9u5kcRYJSMaMOCCwQ",
            "description": "Pariser Platz, Berlin, Germany",
            "types": ["route", "geocode"]
        ])
        correctPredictions.append(allPredictions.last!)
        
        // Prediction with matches
        allPredictions.append([
            "id": "518e47f3d7f39277eb3bc895cb84419c2b43b5ac",
            "place_id": "ChIJmysnFgZYSoYRSfPTL2YJuck",
            "description": "Paris, TX, United States",
            "matched_substrings": [["length": 4, "offset": 0]]
        ])
        correctPredictions.append(allPredictions.last!)
        
        // Prediction with matches and types
        allPredictions.append([
            "id": "e8f77f4687d16d9ffe5271a8ecb4a6bded1fb3f5",
            "place_id": "ChIJW89MjgM",
            "description": "Paris-Charles de Gaulle Airport, Roissy-en-France, France",
            "matched_substrings": [["length": 4, "offset": 0]],
            "types": ["establishment"]
        ])
        correctPredictions.append(allPredictions.last!)
        
        json = [
            "status": "OK",
            "predictions": allPredictions
        ]
        results = PredictionSearchAPIParser.parseResponse(json)
        XCTAssertNil(results.error)
        XCTAssertEqual(results.result.count, correctPredictions.count)

        for i in 0..<results.result.count {
            let prediction = results.result[i]
            let predictionJson = correctPredictions[i]
            XCTAssertEqual(prediction.predictionId, predictionJson["id"] as! String)
            XCTAssertEqual(prediction.placeId, predictionJson["place_id"] as! String)
            XCTAssertEqual(prediction.placeDescription, predictionJson["description"] as! String)
            
            if let types = predictionJson["types"] as? [String] {
                XCTAssertNotNil(prediction.types)
                XCTAssertEqual(prediction.types!.count, types.count)
                for j in 0..<prediction.types!.count {
                    XCTAssertEqual(prediction.types![j], types[j])
                }
            }
            
            if let matches = predictionJson["matched_substrings"] as? [[String: Any]] {
                XCTAssertNotNil(prediction.matches)
                XCTAssertEqual(prediction.matches!.count, matches.count)
                for j in 0..<prediction.matches!.count {
                    XCTAssertEqual(prediction.matches![j].length, matches[j]["length"] as! Int)
                    XCTAssertEqual(prediction.matches![j].offset, matches[j]["offset"] as! Int)
                }
            }
        }
    }
}
