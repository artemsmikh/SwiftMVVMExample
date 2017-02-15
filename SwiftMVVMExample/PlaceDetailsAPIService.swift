//
//  PlaceDetailsAPIService.swift
//  SwiftMVVMExample
//
//  Created by Artem Mikhailov on 08/02/17.
//  Copyright © 2017 Artem Mikhailov. All rights reserved.
//

import Foundation
import Alamofire

final class PlaceDetailsAPIService: PlaceDetailsServiceProtocol {
    
    weak var delegate: PlaceDetailsServiceDelegate?
    
    private(set) var place: PlaceModel? = nil
    
    private var placeId: String
    private var config: GooglePlacesConfig
    private var currentRequest: Request? = nil

    
    init(withPlaceId placeId: String, config: GooglePlacesConfig) {
        self.placeId = placeId
        self.config = config
    }
    
    func loadDetails() {
        // Cancel previous request if exists
        currentRequest?.cancel()
        
        createRequest { (place, error) in
            if let error = error {
                self.delegate?.placeDetailsService(self, didFailToUpdate: error)
            } else {
                self.place = place
                self.delegate?.placeDetailsServiceDidUpdate(self)
            }
        }
    }
    
    private func createRequest(completionHandler: @escaping (_ result: PlaceModel?, _ error: Error?) -> Void) {
        // Build request url
        let (url, urlError) = GooglePlacesUrlBuilder.buildPlaceDetailsUrl(config, placeId: placeId)
        
        guard urlError == nil else {
            completionHandler(nil, urlError)
            return
        }
        
        currentRequest = Alamofire.request(url).responseJSON { response in
            // Parse network response in the default way for Google API
            let responseParseResult = GooglePlacesResponseParser.parseResponse(response)
            
            if let error = responseParseResult.error {
                completionHandler(nil, error)
                return
            }
            
            // Parse correct JSON response
            let placeDetailsParseResult = PlaceDetailsAPIParser.parsePlaceDetailsResponse(from: responseParseResult.json!, config: self.config)
            
            if let error = placeDetailsParseResult.error {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(placeDetailsParseResult.result!, nil)
        }
    }
}
