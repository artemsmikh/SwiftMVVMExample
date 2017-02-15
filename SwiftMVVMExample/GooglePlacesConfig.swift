//
//  GooglePlacesConfig.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 06/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

final class GooglePlacesConfig {
    let maxImageSize: Int = 600
    
    private(set) var apiKey: String = ""
    
    init(plistName name: String) {
        // Check for both default and example paths (just in case
        // when someone hasn't renamed example .plist file)
        let defaultPath = Bundle.main.path(forResource: name, ofType: "plist")
        let examplePath = Bundle.main.path(forResource: name, ofType: "plist.example")
        
        if let path = defaultPath ?? examplePath {
            let config = NSDictionary(contentsOfFile: path)
            
            if let value = config?.object(forKey: "apiKey") as? String {
                apiKey = value
            }
        }
    }
}
