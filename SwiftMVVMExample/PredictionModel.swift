//
//  PredictionModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 02/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

final class PredictionModel {
    var predictionId: String
    var placeId: String
    var placeDescription: String
    var types: [String]?
    var matches: [(offset: Int, length: Int)]?
    
    init(predictionId: String, placeId: String, placeDescription: String) {
        self.predictionId = predictionId
        self.placeId = placeId
        self.placeDescription = placeDescription
    }
}
