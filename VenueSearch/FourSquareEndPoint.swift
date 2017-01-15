//
//  FourSquareEndPoint.swift
//  VenueSearch
//
//  Created by Conny Yang on 8/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import Foundation

enum FourSquareEndPoint
{
    case search(clientID: String, clientSecret: String, coordinate: Coordinate, query: String?, searchRadius: Int?)
    
    var baseURL: String {
        return "https://api.foursquare.com"
    }
    
    var path: String {
        switch self {
        case .search: return "/v2/venues/search"
        }
    }
    
    private struct ParameterKeys {
        static let clientID = "client_id"
        static let clientSecret = "client_secret"
        static let version = "v"
        static let category = "categoryId"
        static let location = "ll"
        static let query = "query"
        static let limit = "limit"
        static let searchRadius = "radius"
    }
    
    private struct DefaultValues {
        static let version = "20160828"
        static let limit = "50"
        static let searchRadius = "2000"
    }
    
    var parameters : [String : Any] {
        switch self {
        case .search(let clientID, let clientSecret, let coordinate, let query, let searchRadius):
            var parameters : [String : Any] = [
                ParameterKeys.clientID : clientID,
                ParameterKeys.clientSecret : clientSecret,
                ParameterKeys.version : DefaultValues.version,
                ParameterKeys.location : coordinate.description
            ]
            
            if let query = query{
                parameters[ParameterKeys.query] = query
            }
            
            if let searchRadius = searchRadius {
                parameters[ParameterKeys.searchRadius] = searchRadius
            }
            else
            {
                parameters[ParameterKeys.searchRadius] = DefaultValues.searchRadius
            }
            
            return parameters
        }
    }
    
    var queryComponents : [URLQueryItem] {
        var queryComponents = [URLQueryItem]()
        
        for(key, value) in parameters
        {
            let queryItem = URLQueryItem(name: "\(key)", value: "\(value)")
            queryComponents.append(queryItem)
        }
        
        return queryComponents
    }
    
    var request : URLRequest{
        var component = URLComponents(string: baseURL)!
        component.path = path
        component.queryItems = queryComponents
        
        let url = component.url!
        return URLRequest(url: url)
        
    }
    
}
