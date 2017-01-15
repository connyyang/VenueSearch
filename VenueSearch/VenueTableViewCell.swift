//
//  VenueTableViewCell.swift
//  VenueSearch
//
//  Created by Conny Yang on 12/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {
    
    var venue : Venue!{
        didSet{
            updateUI()
        }
    }
    
    var fourSquareClient : FourSquareClient!

    @IBOutlet weak var venueImage: UIImageView!
    
    @IBOutlet weak var venueName: UILabel!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var checkinsLabel: UILabel!
    
    func updateUI(){
        venueName.text = venue.name
        categoryName.text = venue.categoryName
        checkinsLabel.text = String(venue.checkins)
        
        if let distance = venue.location?.distance {
            distanceLabel.text = "\(distance)mi"
        }
        else
        {
            distanceLabel.isHidden = true
        }
        
        if let fourSquareClient = fourSquareClient, let categoryURL = venue.categoryIconURL{
            fourSquareClient.fetchDataFor(url: categoryURL, completion: { (result) in
                switch result{
                case .success(let data):
                    self.venueImage.image = UIImage(data: data)
                    self.venueImage.backgroundColor = UIColor.random()
                    self.venueImage.layer.cornerRadius = self.venueImage.bounds.width / 2.0
                    self.venueImage.clipsToBounds = true
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        
    }
    
}

private extension UIColor
{
    class func random() -> UIColor
    {
        var colors = [
            UIColor(red: 245/255.0, green: 166/255.0, blue: 35/255.0, alpha: 1.0),
            UIColor(red: 144/255.0, green: 19/255.0, blue: 254/255.0, alpha: 1.0),
            UIColor(red: 249/255.0, green: 103/255.0, blue: 30/255.0, alpha: 1.0),
            UIColor(red: 35/255.0, green: 141/255.0, blue: 255/255.0, alpha: 1.0),
            UIColor(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1.0)
        ]
        let random = Int(arc4random()) % colors.count
        
        return colors[random]
    }
}

