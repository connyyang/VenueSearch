//
//  VenueTableViewController.swift
//  VenueSearch
//
//  Created by Conny Yang on 11/01/2017.
//  Copyright © 2017 Conny Yang. All rights reserved.
//

import UIKit
import SafariServices
import MapKit

class VenueTableViewController: UITableViewController {
    
    @IBOutlet weak var headerStackView: UIStackView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var venues = [Venue]() {
        didSet{
            self.tableView.reloadData()
            addVenueAnnotations()
        }
    }
    
    var locationManager = LocationManager()
    
    var fourSquareClient : FourSquareClient!
    
    var clientID: String = "EV3LGPWPNGBQ2MRFABCW0AEIAWYNMKHQ0EPS3RDTINSRMAD2"
    var clientSecret: String = "XANXUPKQXL2KRSPP5I241IYXXUJUU0QVOMGJMQJ2M14OVT0X"
    
    var coordinate : Coordinate?{
        didSet{
            fetchVenues()
        }
    }
    
    let searchBarController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.rowHeight = 71
        self.tableView.estimatedRowHeight = 71
        print("row height: \(self.tableView.rowHeight)")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Location Manager Service
        locationManager.getPermission()
        locationManager.didGetLocation = { coordinate in
            self.coordinate = coordinate
        }
        
        mapView.delegate = self
        
        // Configure Search Bar
        searchBarController.searchResultsUpdater = self
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        headerStackView.addSubview(searchBarController.searchBar)

    }
    
    struct StoryBoard
    {
        static let venueCell = "VenueCell"
    }
    
    @IBAction func fetchVenues()
    {
        if let coordinate = coordinate {
            fourSquareClient = FourSquareClient(clientID: clientID, clientSecret: clientSecret)
            fourSquareClient.fetchVenuesFor(coordinate: coordinate, completion: { (result) in
                switch result {
                case .success(let venues):
                    self.venues = venues
                    //print(venues)
                    
                    self.tableView.refreshControl?.endRefreshing()
                case .failure(let error):
                    print(error)
                    
                }
            })
        }
    }
    
    func addVenueAnnotations()
    {
        if venues.count > 0
        {
            let annotations : [MKPointAnnotation] = venues.map{ venue in
                let pointAnnotation = MKPointAnnotation()
                if let coordinate = venue.location?.coordinate
                {
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longtitude)
                    pointAnnotation.title = venue.name
                    pointAnnotation.subtitle = venue.categoryName
                }
                
                return pointAnnotation
            }
            mapView.addAnnotations(annotations)
        }
    }


}

extension VenueTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryBoard.venueCell) as! VenueTableViewCell
        
        let venue = venues[indexPath.row]
        
        cell.fourSquareClient = self.fourSquareClient
        cell.venue = venue
        
        return cell
    }
}

extension VenueTableViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.venues[indexPath.row]
        
        if let url = cell.url
        {
           let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Warning", message: "This url cannot be found!", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(alertAction)
            
            self.present(alertController, animated: true, completion: nil)

        }
    }
}

// MAP Delegate
extension VenueTableViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        var region = MKCoordinateRegion()
        region.center = userLocation.coordinate
        region.span.latitudeDelta = 0.001
        region.span.longitudeDelta = 0.001
        
        mapView.setRegion(region, animated: true)
    }
}

extension VenueTableViewController : UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        if let coordinate = coordinate {
            fourSquareClient.fetchVenuesFor(coordinate: coordinate, query: searchBarController.searchBar.text,  completion: { (result) in
                switch result{
                case .success(let venues):
                    self.venues = venues
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}

