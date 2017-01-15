//
//  ViewController.swift
//  VenueSearch
//
//  Created by Conny Yang on 7/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let baseURL = "https://api.foursquare.com/v2/"
        let path = "venues/search?ll=40.7,-74&client_id=EV3LGPWPNGBQ2MRFABCW0AEIAWYNMKHQ0EPS3RDTINSRMAD2&client_secret=XANXUPKQXL2KRSPP5I241IYXXUJUU0QVOMGJMQJ2M14OVT0X&v=20160827"
        let urlString = "\(baseURL)\(path)"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        let networkProcessing = NetworkProcessing(request: urlRequest)
        networkProcessing.downloadJSON { (json, response, error) in
             print("**********2************")
            print(json)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

