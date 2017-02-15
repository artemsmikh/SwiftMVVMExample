//
//  PredictionCellViewModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 07/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import UIKit

class PredictionCellViewModel {
    fileprivate var prediction: PredictionModel
    
    init(withPrediction prediction: PredictionModel) {
        self.prediction = prediction
    }
    
    fileprivate var nameFont: UIFont {
        return UIFont.systemFont(ofSize: UIFont.labelFontSize)
    }
    
    fileprivate var matchedNameFont: UIFont {
        return UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    }
    
    fileprivate var matchedNameColor: UIColor {
        return UIColor(red: 66/255, green: 133/255, blue: 254/255, alpha: 1)
    }
}

extension PredictionCellViewModel: PredictionCellViewModelProtocol {
    var name: NSAttributedString {
        // Attributed string with a place desription, matches marked in bold
        let name = prediction.placeDescription
        let font = [NSFontAttributeName: nameFont]
        let result = NSMutableAttributedString(string: name, attributes: font)
        
        if let matches = prediction.matches, matches.count > 0 {
            // Make matches bold
            let matchAttributes = [NSForegroundColorAttributeName: matchedNameColor,
                                   NSFontAttributeName: matchedNameFont]
            
            for match in matches {
                let range = NSRange(location: match.offset, length: match.length)
                result.addAttributes(matchAttributes, range: range)
            }
        }
        
        return result
    }
    
    var types: String {
        // String with a sequence of types
        var result = ""
        if let types = prediction.types, types.count > 0 {
            for type in types {
                // Replace underscores with spaces 
                // (e.g. 'transit_station' becomes 'transit station')
                result += type.replacingOccurrences(of: "_", with: " ")
                if type != types.last! {
                    result += ", "
                }
            }
        }
        return result
    }
}
