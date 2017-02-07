//
//  PredictionSearchViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PredictionSearchViewModelProtocol {
    var delegate: PredictionSearchViewModelDelegate? { get set }
    
    var searchText: String { get set }
    
    var searchPlaceholderText: String { get }
    
    var displayTooltip: Bool { get }
    var tooltipText: String { get }
    
    var cells: [PredictionCellViewModelProtocol] { get }
}

protocol PredictionSearchViewModelDelegate {
    func predictionSearchViewModelDidUpdateTooltip(_ viewModel: PredictionSearchViewModelProtocol)
    func predictionSearchViewModelDidUpdatePredictions(_ viewModel: PredictionSearchViewModelProtocol)
}
