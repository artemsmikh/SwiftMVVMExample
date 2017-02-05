//
//  PredictionSearchMockServiceTest.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 05/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import XCTest

class PredictionSearchMockServiceTest: XCTestCase {
    fileprivate var predictions: [PredictionModel]? = nil
    fileprivate var error: Error? = nil
    fileprivate var timeExpectation: XCTestExpectation? = nil
    
    private var service: PredictionSearchService?
    
    override func setUp() {
        super.setUp()
        
        service = PredictionSearchMockService()
        service!.delegate = self
    }
    
    override func tearDown() {
        predictions = nil
        error = nil
        timeExpectation = nil
        
        service = nil
        
        super.tearDown()
    }
    
    func testMockService() {
        XCTAssertNotNil(service)
        
        // Test initial values
        XCTAssertTrue(service!.predictions.count == 0)
        XCTAssertTrue(service!.searchText.characters.count == 0)
        
        // Test mock search results
        timeExpectation = expectation(description: "mock search results")
        service!.searchText = "Abcde"
        
        waitForExpectations(timeout: 0.1) { (_) in
            // Check mock results
            XCTAssertNil(self.error)
            XCTAssertNotNil(self.predictions)
            XCTAssertTrue(self.predictions!.count > 0)
            
            for i in 0..<self.predictions!.count {
                let prediction = self.predictions![i]
                XCTAssertEqual("\(i + 1)", prediction.predictionId)
                XCTAssertEqual("\(i + 1)", prediction.placeId)
                XCTAssertEqual("Prediction \(i + 1)", prediction.placeDescription)
            }
        }
        
        // Test search with a short string
        timeExpectation = expectation(description: "mock search results for a short text")
        service!.searchText = "A"
        
        waitForExpectations(timeout: 0.1) { (_) in
            // Check mock results (should be empty)
            XCTAssertNil(self.error)
            XCTAssertNotNil(self.predictions)
            XCTAssertTrue(self.predictions!.count == 0)
        }
        
        // Test search with an empty string
        timeExpectation = expectation(description: "mock search results for an empty text")
        service!.searchText = ""
        
        waitForExpectations(timeout: 0.1) { (_) in
            // Check mock results (should be empty)
            XCTAssertNil(self.error)
            XCTAssertNotNil(self.predictions)
            XCTAssertTrue(self.predictions!.count == 0)
        }
    }
}

extension PredictionSearchMockServiceTest: PredictionSearchServiceDelegate {
    
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchService) {
        self.timeExpectation?.fulfill()
        self.error = nil
        self.predictions = service.predictions
    }
    
    func predictionSearchService(_ service: PredictionSearchService, didFailToUpdatePredictions error: Error) {
        self.timeExpectation?.fulfill()
        self.error = error
        self.predictions = service.predictions
    }
}
