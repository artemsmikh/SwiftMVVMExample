//
//  PredictionSearchViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PredictionSearchViewModelProtocol {
    weak var delegate: PredictionSearchViewModelDelegate? { get set }
    
    var searchText: String { get set }
    
    var searchPlaceholderText: String { get }
    var tooltipText: String { get }
    
    var displayTooltip: Bool { get }
    var displayLoadingIndicator: Bool { get }
    var displayTable: Bool { get }
    
    var cells: [PredictionCellViewModelProtocol] { get }
    
    func onSelectCell(withIndex index: Int)
}

protocol PredictionSearchViewModelDelegate: class {
    func predictionSearchViewModelDidUpdateTooltip(_ viewModel: PredictionSearchViewModelProtocol)
    func predictionSearchViewModelDidUpdatePredictions(_ viewModel: PredictionSearchViewModelProtocol)
    func predictionSearchViewModel(_ viewModel: PredictionSearchViewModelProtocol, showPlaceDetails placeDetailsViewModel: PlaceDetailsViewModelProtocol)
    func predictionSearchViewModelDidUpdateLoadingIndicator(_ viewModel: PredictionSearchViewModelProtocol)
}
