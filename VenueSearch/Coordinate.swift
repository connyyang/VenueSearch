//
//  Coordinate.swift
//  VenueSearch
//
//  Created by Conny Yang on 7/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import Foundation

struct Coordinate : CustomStringConvertible
{
    let latitude : Double
    
    let longtitude : Double
    
    var description: String {
        return ("\(latitude),\(longtitude)")
        
    }
}
