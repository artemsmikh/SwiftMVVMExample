//
//  GooglePlacesError.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 08/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

enum GooglePlacesError: Error {
    case InvalidResponse
    case WrongResponseFormat
    case IncorrectResponseStatus
    case IncorrectInput
}

extension GooglePlacesError: CustomStringConvertible {
    var description: String {
        switch self {
        case .InvalidResponse:
            return "Invalid response"
            
        case .WrongResponseFormat:
            return "Wrong response format"
            
        case .IncorrectResponseStatus:
            return "Incorrect response status"
            
        case .IncorrectInput:
            return "Incorrect input"
        }
    }
}
