//
//  GooglePlacesConfig.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 06/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

class GooglePlacesConfig {
    private(set) var apiKey: String = ""
    
    init(plistName name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "plist") {
            let config = NSDictionary(contentsOfFile: path)
            
            if let value = config?.object(forKey: "apiKey") as? String {
                apiKey = value
            }
        }
    }
}
