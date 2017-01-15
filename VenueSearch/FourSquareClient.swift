//
//  FourSquareClient.swift
//  VenueSearch
//
//  Created by Conny Yang on 9/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import Foundation

class FourSquareClient
{
    let clientID : String
    let clientSecret : String
    
    init(clientID : String, clientSecret : String)
    {
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    func fetchVenuesFor(coordinate : Coordinate, query: String? = nil, searchRadius : Int? = nil, completion : @escaping (APIResult<[Venue]>) -> Void)
    {
        let searchEndPoint = FourSquareEndPoint.search(clientID: clientID, clientSecret: clientSecret, coordinate: coordinate, query: query, searchRadius: searchRadius)
        
        let request = searchEndPoint.request
        
        let networkProcessing = NetworkProcessing.init(request: request)
        
        networkProcessing.downloadJSON { (json, httpResponse, error) in
            DispatchQueue.main.async {
                guard let json = json else{
                    if let error = error{
                        completion(.failure(error))
                    }
                    
                    return
                }
                
                guard let response = json["response"] as? [String : Any], let venueDictionries = response["venues"] as? [[String : Any]] else{
                    
                    let error = NSError(domain: DMname, code: UnexpectedResponseError, userInfo: nil)
                    completion(.failure(error))
                    
                    return
                }
                
                let venues = venueDictionries.flatMap{ venueDict in
                    return Venue(json: venueDict)
                }
                
                completion(.success(venues))
            }
        }
    }
    
    func fetchDataFor(url : URL, completion : @escaping (APIResult<Data>) -> Void){
        let urlRequest = URLRequest(url: url)
        let networkProcessing = NetworkProcessing.init(request: urlRequest)
        networkProcessing.downloadData { (data, httpResponse, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    completion(.success(data))
                }
                
            }
        }
        
    }
}
