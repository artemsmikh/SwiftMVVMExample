//
//  PlaceDetailsAPIParser.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 08/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation

final class PlaceDetailsAPIParser {
    
    static func parsePlaceDetailsResponse(from response: [String: Any], config: GooglePlacesConfig) -> (result: PlaceModel?, error: Error?) {
        // Check that json has a "result" key
        guard let info = response["result"] as? [String: Any] else {
            return (nil, GooglePlacesError.WrongResponseFormat)
        }
        
        // Parse place details
        guard let placeDetails = parsePlaceDetails(from: info, config: config) else {
            return (nil, GooglePlacesError.WrongResponseFormat)
        }
        
        // Return parsed place
        return (placeDetails, nil)
    }
    
    private static func parsePlaceDetails(from info: [String: Any], config: GooglePlacesConfig) -> PlaceModel? {
        // Check for all necessary values
        guard let id = info["place_id"] as? String,
              let name = info["name"] as? String else {
                return nil;
        }
        
        let place = PlaceModel(placeId: id, name: name)
        
        place.rating = info["rating"] as? Float
        place.address = info["formatted_address"] as? String
        place.phone = info["international_phone_number"] as? String
        
        if let website = info["website"] as? String {
            place.website = URL(string: website)
        }
        
        if let url = info["url"] as? String {
            place.url = URL(string: url)
        }
        
        if let icon = info["icon"] as? String {
            place.icon = URL(string: icon)
        }
        
        if let photos = info["photos"] as? [Any] {
            for photo in photos {
                guard let photoInfo = photo as? [String: Any] else {
                    continue
                }
                
                guard let photoReference = photoInfo["photo_reference"] as? String else {
                    continue
                }
                
                if let url = urlFromPhotoReference(photoReference, config: config) {
                    place.photos.append(url)
                }
            }
        }
        
        return place
    }
    
    private static func urlFromPhotoReference(_ reference: String, config: GooglePlacesConfig) -> URL? {
        let (url, urlError) = GooglePlacesUrlBuilder.buildPhotoUrl(config, reference: reference)
        
        guard urlError == nil else {
            return nil
        }
        
        return URL(string: url)
    }
}
