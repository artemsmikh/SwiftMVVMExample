//
//  PredictionSearchAPIModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 03/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import Alamofire

class PredictionSearchAPIModel {
    let minimalSearchTextLength = 3
    
    var searchText: String = "" {
        didSet {
            // Perform a new search when value is changed
            search()
        }
    }
    
    private(set) var predictions: [PredictionModel] = [] {
        didSet {
            // TODO: Notify about changes
        }
    }
    
    private var currentRequest: Request?
    
    private func search() {
        // Cancel previous request
        currentRequest?.cancel()
        currentRequest = nil
        
        // Check search text length
        if searchText.characters.count >= minimalSearchTextLength {
            // TODO: Perform a new search
        } else {
            // Clear old values
            predictions = []
        }
    }
}
