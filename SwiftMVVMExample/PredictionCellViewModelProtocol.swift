//
//  PredictionCellViewModelProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PredictionCellViewModelProtocol {
    var name: NSAttributedString { get }
    var types: String { get }
}
