//
//  SingleServiceView.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 3/26/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import MapKit

class SingleServiceViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var serviceImage: UIImageView!
    // service title
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceProviderName: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var servicePhone: UILabel!
    @IBOutlet weak var serviceEmail: UILabel!
    
    @IBOutlet weak var serviceDescription: UITableViewCell!
//    @IBOutlet weak var serviceDescription: UILabel!
    @IBOutlet var profileIconImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var service: Service?
    var Profilebase64String: String = ""
    var ProfiledecodedData:NSData?
    var ProfiledecodedImage:UIImage?
    
    let cellHeights = []
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        if let service = service {
            initComponents(service)
        }
        
        // setup map
        mapView.delegate = self
        
        let addresss = service!.fullAddress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addresss, completionHandler: { (placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                
                let mapPoint = MapPoint(title: (self.service?.title)!, locationName: (self.service?.fullAddress())!, coordinate: (placemark.location?.coordinate)!)
                
                self.mapView.addAnnotation(mapPoint)
                
                let initialLocation = placemark.location
                self.centerMapOnLocation((initialLocation?.coordinate)!)
            }
        })
        
//        userIDRef.observeEventType(.Value, withBlock: { snapshot in
//            //Pull in Image from Firebase
//            self.Profilebase64String = (snapshot.value.objectForKey("Base64Image") as? String)!
//            self.ProfiledecodedData = NSData(base64EncodedString: self.Profilebase64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
//            self.ProfiledecodedImage = UIImage(data: self.ProfiledecodedData!)!
//            
//            self.profileIconImage.image = self.ProfiledecodedImage
//            self.profileIconImage.contentMode = .ScaleAspectFill
//            self.profileIconImage.layer.cornerRadius = self.profileIconImage.frame.size.width / 2;
//            self.profileIconImage.clipsToBounds = true;        
//            
//            }, withCancelBlock: { error in
//                print(error.description)
//        })
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
//        profileIconImage.userInteractionEnabled = true
//        profileIconImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    
    func initComponents(service: Service) {
        
        // navigation bar
        let navbar = self.navigationController?.navigationBar
        navbar!.barTintColor = UIColor.domoBlue()
        navbar?.tintColor = UIColor.whiteColor()

        serviceImage.image = service.image
        servicePrice.text = "$" + service.price
        serviceAddress.text = service.streetAddress
        servicePhone.text = service.phone
        serviceEmail.text = service.serviceEmail
        
        let descriptionLabel = serviceDescription.textLabel
        
        descriptionLabel!.text = service.description
        descriptionLabel!.numberOfLines = 10
        descriptionLabel!.font = descriptionLabel?.font.fontWithSize(14)
        
        // set service provider name
        fetchServiceProvider(service.uid)
    }
    
    
    func fetchServiceProvider(uid: String!) {
        let usersRef = ref.childByAppendingPath("users")
        let serviceProviderRef = usersRef.childByAppendingPath(uid)
        
        // get serviece provider
        serviceProviderRef.observeEventType(.Value, withBlock: { snapshot in
            
            // get user's name, offering service
            let fname = (snapshot.value.objectForKey("FirstName") as? String)!
            let lname = (snapshot.value.objectForKey("LastName") as? String)!
            self.serviceProviderName.text = fname + " " + lname
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.text = service?.title
        header.textLabel?.textColor = UIColor.whiteColor()
        header.textLabel?.textAlignment = NSTextAlignment.Center
        header.textLabel!.font = UIFont(name: "Helvetica Neue", size: 18)
        header.tintColor = UIColor.domoBlue()
        header.frame.size.height    = CGFloat(44.0)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath)
        let height: CGFloat
        
        if indexPath.row == 0 {
            height = 175.0
        } else {
            height = ceil(cell.systemLayoutSizeFittingSize(CGSizeMake(self.tableView.bounds.size.width, 1), withHorizontalFittingPriority: 1000, verticalFittingPriority: 1).height)
        }
        
        return height
    }
    
    // MARK: Location Services
    
    let regionRadius: CLLocationDistance = 1000
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func imageTapped(img: AnyObject)
    {
        //send them to home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("userProfile") as UIViewController
        self.presentViewController(MainPageViewController, animated: true, completion: nil)
    }
    
    // MARK: Action
    
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}