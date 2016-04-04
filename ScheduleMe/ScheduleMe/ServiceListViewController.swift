//
//  ServiceListViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import CoreLocation

class ServiceListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    
    
    // MARK: Properties
    
    @IBOutlet var ProfileIconImage: UIImageView!
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // firebase
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var base64String: String = ""
    var decodedData:NSData?
    var decodedImage:UIImage?
    var services = [Service]()
    
    // search
    var filteredServices = [Service]()
    let searchController = UISearchController(searchResultsController: nil)
    
    // locationManager
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    var alerted = false
    

    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup table view
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        
        initSearchBar()
        initLocationManager()
        
        // fetch data
        fetchServicesFromFirebase()
        fetchUserFromFirebase()
        
    }
    
    func fetchUserFromFirebase() {
        
        //Prep to set FirebaseImage
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        // get profile picture
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            //Pull in Image from Firebase
            self.base64String = (snapshot.value.objectForKey("Base64Image") as? String)!
            self.decodedData = NSData(base64EncodedString: self.base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.decodedImage = UIImage(data: self.decodedData!)!
            
            self.ProfileIconImage.image = self.decodedImage
            self.ProfileIconImage.contentMode = .ScaleAspectFill
            self.ProfileIconImage.layer.cornerRadius = self.ProfileIconImage.frame.size.width / 2;
            self.ProfileIconImage.clipsToBounds = true;
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:")  )
        ProfileIconImage.userInteractionEnabled = true
        ProfileIconImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    func fetchServicesFromFirebase() {
        let serviceRef = self.ref.childByAppendingPath("services")
        
        serviceRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Service]()
            
            for item in snapshot.children {
                let service = Service(snapshot: item as! FDataSnapshot)
                newItems.append(service)
            }
            
            self.services = newItems
            
            self.serviceTableView.reloadData()
        })
    }
    
    func initSearchBar() {
        // setup search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        serviceTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.placeholder = "Search service, city, zip"
    }
    
    
    
    // MARK: UISearchController
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredServices = services.filter { service in
            
            let titleMatch = service.title.lowercaseString.containsString(searchText.lowercaseString)
            let cityMatch = service.city.lowercaseString.containsString(searchText.lowercaseString)
            let stateMatch = service.state.lowercaseString.containsString(searchText.lowercaseString)
            let zipMatch = service.zip.lowercaseString.containsString(searchText.lowercaseString)
            
            return titleMatch || cityMatch || stateMatch || zipMatch
        }
        
        serviceTableView.reloadData()
    }
    
    
    
    // MARK: Locations
    
    func initLocationManager() {
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.userLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            return self.filteredServices.count
        }
        
        return self.services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        // get cell
        let cellIdentifier = "ServiceTableViewCell"
        
        let cell = serviceTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ServiceTableViewCell
        
        // get service
        let service: Service
        
        if searchController.active && searchController.searchBar.text != "" {
            service = self.filteredServices[indexPath.row]
        } else {
            service = self.services[indexPath.row]
        }
        
        
        // populate cell
        
        cell.titleLabel.text = service.title
        cell.cityLabel.text = service.city + ", " + service.state
        cell.descriptionLabel.text = service.description
        
        
        // distance
        let address = service.fullAddress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("address not found: \(address)")
            }
            
            if let placemark = placemarks?.first {
                
                if self.userLocation != nil {
                    // get location
                    let serviceLocation = (placemark.location?.coordinate)!
                    
                    // create coordinate
                    let lat = serviceLocation.latitude
                    let long = serviceLocation.longitude
                    let coordinte = CLLocation(latitude: lat, longitude: long)
                    
                    let meters:CLLocationDistance = self.userLocation!.distanceFromLocation(coordinte)
                    let miles = Double((meters/1000.0)*0.62137).roundToPlaces(1)
                    
                    // round to 2 decimal places
                    cell.distanceLabel.text = String(miles) + " Mi"
                } else {
                    cell.distanceLabel.text = ""
                    
                    if !self.alerted {
                        self.alerted = true
                        let alertController = UIAlertController(title: "Location Services", message: "Enable loction services to view your distance from each service", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
        })
        
        // price
        var price = service.price
        let index = price.characters.indexOf(".")
        
        if price != "" && index != nil {
            price = price.substringToIndex(index!)
        }
        
        cell.priceLabel.text = "$" + price
        
        // image
        cell.setImageTo("defaultServiceImage")
        if let image = service.image {
            cell.serviceImage.image = image
        }
        
        return cell
    }
    
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            
            let singleServiceViewController = navigationController.viewControllers.first as! SingleServiceViewController
            
            
            if let selectedCell = sender as? ServiceTableViewCell {
                let indexPath = serviceTableView.indexPathForCell(selectedCell)
                
                let selectedService: Service
                
                if searchController.active && searchController.searchBar.text != "" {
                    selectedService = self.filteredServices[indexPath!.row]
                } else {
                    selectedService = self.services[indexPath!.row]
                }
                
                singleServiceViewController.service = selectedService
            }
        }
    }
    
    
    
    // MARK: Actions
    
    func imageTapped(img: AnyObject)
    {
        //send them to home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("userProfile") as UIViewController
        self.presentViewController(MainPageViewController, animated: true, completion: nil)
    }

}

extension ServiceListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension ServiceListViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}