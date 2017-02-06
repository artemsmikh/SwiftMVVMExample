//
//  PredictionSearchService.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 05/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PredictionSearchService {
    var delegate: PredictionSearchServiceDelegate? { get set }
    
    var searchText: String { get set }
    var predictions: [PredictionModel] { get }
}

protocol PredictionSearchServiceDelegate {
    func predictionSearchServiceDidUpdatePredictions(_ service: PredictionSearchService)
    func predictionSearchService(_ service: PredictionSearchService, didFailToUpdatePredictions error: Error)
}

enum PredictionSearchServiceError: Error {
    case RequestFailure(message: String)
}
