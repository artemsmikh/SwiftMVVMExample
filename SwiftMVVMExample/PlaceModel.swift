//
//  PlaceModel.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 02/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

class PlaceModel {
    var placeId: String
    var name: String
    var rating: Float?
    var icon: URL?
    var url: URL?
    var website: URL?
    var address: String?
    var phone: String?
    var photos: [URL] = []
    
    var phoneUrl: URL? {
        if let phone = phone {
            if let phoneUrlString = "telprompt://\(phone)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: phoneUrlString)
            }
        }
        return nil
    }
    
    init(placeId: String, name: String) {
        self.placeId = placeId
        self.name = name
    }
}
