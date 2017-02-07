//
//  PredictionSearchService.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 05/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PredictionSearchService {
    var status: PredictionSearchServiceStatus { get }
    
    var delegate: PredictionSearchServiceDelegate? { get set }
    
    var searchText: String { get set }
    var predictions: [PredictionModel] { get }
}

enum PredictionSearchServiceStatus {
    case ShortInput
    case Loading
    case HasResults
    case NoResults
}

protocol PredictionSearchServiceDelegate {
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchService)
    func predictionSearchService(_ service: PredictionSearchService, didFailToUpdatePredictions error: Error)
}
