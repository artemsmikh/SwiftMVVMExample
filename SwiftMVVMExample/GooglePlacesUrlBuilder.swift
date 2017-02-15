//
//  GooglePlacesUrlBuilder.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 15/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

final class GooglePlacesUrlBuilder {
    
    // MARK: Public functions
    static func buildPredictionsSearchUrl(_ config: GooglePlacesConfig, input: String) -> (url: String, error: Error?) {
        return buildUrl(from: "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=\(config.apiKey)&input=\(input)")
    }
    
    static func buildPlaceDetailsUrl(_ config: GooglePlacesConfig, placeId: String) -> (url: String, error: Error?) {
        return buildUrl(from: "https://maps.googleapis.com/maps/api/place/details/json?key=\(config.apiKey)&placeid=\(placeId)")
    }
    
    static func buildPhotoUrl(_ config: GooglePlacesConfig, reference: String) -> (url: String, error: Error?) {
        return buildUrl(from: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=\(config.maxImageSize)&photoreference=\(reference)&key=\(config.apiKey)")
    }
    
    
    // MARK: Private functions
    
    private static func buildUrl(from urlString: String) -> (url: String, error: Error?) {
        guard let escapedUrl = escaped(urlString) else {
            return ("", GooglePlacesError.IncorrectInput)
        }
        
        return (escapedUrl, nil)
    }
    
    private static func escaped(_ string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
