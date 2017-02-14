//
//  PlaceDetailsServiceProtocol.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 08/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

protocol PlaceDetailsServiceProtocol {
    weak var delegate: PlaceDetailsServiceDelegate? { get set }
    
    var place: PlaceModel? { get }
    
    func loadDetails()
}

protocol PlaceDetailsServiceDelegate: class {
    func placeDetailsServiceDidUpdate(_ service: PlaceDetailsServiceProtocol)
    func placeDetailsService(_ service: PlaceDetailsServiceProtocol, didFailToUpdate error: Error)
}
