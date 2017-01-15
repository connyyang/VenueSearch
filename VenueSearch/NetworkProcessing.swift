//
//  NetworkProcessing.swift
//  VenueSearch
//
//  Created by Conny Yang on 7/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

//
//  NetworkProcessing.swift
//  NetworkProcessing
//
//  Created by Conny Yang on 5/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import Foundation

public let DMname = "\(Bundle.main.bundleIdentifier).NetworkProcessing"
public let MissingHttpResponseErrorCode = 10
public let UnexpectedResponseError: Int = 20

class NetworkProcessing
{
    var request : URLRequest
    
    lazy var configuration : URLSessionConfiguration = URLSessionConfiguration.default
    
    lazy var session : URLSession = URLSession(configuration: self.configuration)
    
    
    typealias JSON = [String : Any]
    typealias JSONHandler = (JSON?, HTTPURLResponse?, Error?) -> Void
    typealias DataHandler = (Data?, HTTPURLResponse?, Error?) -> Void
    
    init(request : URLRequest) {
        self.request = request
    }
    
    func downloadJSON(completion: @escaping JSONHandler)
    {
        
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else{
                let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("Missing HTTP Response", comment: "")]
                
                let error = NSError(domain: DMname, code: MissingHttpResponseErrorCode, userInfo: userInfo)
                
                completion(nil, nil, error as Error)
                return
            }
            
            if data == nil
            {
                if let error = error
                {
                    completion(nil, httpResponse, error)
                }
            }
            else
            {
                switch httpResponse.statusCode {
                case 200:
                    // OK
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! JSON
                        completion(json, httpResponse, nil)
                        
                    }catch{
                        completion(nil, httpResponse, error)
                    }
                    
                default:
                    print("Http Response Status Code: \(httpResponse.statusCode)")
                   // print("\(self.request.url)")
                }
            }
            
        }
        
        dataTask.resume()
    }
    
    func downloadData(completion: @escaping DataHandler) {
        let dataTask = session.dataTask(with: self.request) { (data, response, error) in
            // OFF THE MAIN THREAD
            // Error: missing http response
            guard let httpResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey : NSLocalizedString("Missing HTTP Response", comment: "")]
                let error = NSError(domain: DMname, code: MissingHttpResponseErrorCode, userInfo: userInfo)
                completion(nil, nil, error as Error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, httpResponse, error)
                }
            } else {
                switch httpResponse.statusCode {
                case 200:
                    completion(data, httpResponse, nil)
                default:
                    print("Received HTTP response code: \(httpResponse.statusCode) - was not handled in NetworkProcessing.swift")
                }
            }
        }
        
        dataTask.resume()
    }
       
}

