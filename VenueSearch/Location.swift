//
//  Location.swift
//  VenueSearch
//
//  Created by Conny Yang on 7/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import Foundation

struct Location
{
    let coordinate : Coordinate?
    let address : String?
    let distance : Double?
    let postcode : String?
    let city : String?
    let state : String?
    let country : String?
    let countryCode : String?
    let crossStreet : String?
    
    init?(json: [String : Any])
    {
        if let latitude = json["lat"] as? Double, let longitude = json["lng"] as? Double{
            coordinate = Coordinate(latitude: latitude, longtitude: longitude)
        }
        else
        {
            coordinate = nil
        }
        
        address = json["address"] as? String
        distance = json["distance"] as? Double
        postcode = json["postalCode"] as? String
        city = json["city"] as? String
        state = json["state"] as? String
        country = json["country"] as? String
        countryCode = json["cc"] as? String
        crossStreet = json["crossStreet"] as? String
    }
}
