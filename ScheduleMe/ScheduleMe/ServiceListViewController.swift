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

class ServiceListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var ProfileIconImage: UIImageView!

    // MARK: Properties
    
    var services = [Service]()
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    // firebase
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var base64String: String = ""
    var decodedData:NSData?
    var decodedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Prep to set FirebaseImage
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        fetchServicesFromFirebase()
        
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
    
    func imageTapped(img: AnyObject)
    {
        //send them to home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("userProfile") as UIViewController
        self.presentViewController(MainPageViewController, animated: true, completion: nil)
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
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ServiceTableViewCell"
        
        let cell = serviceTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ServiceTableViewCell
        
        let service = self.services[indexPath.row]
        
        cell.titleLabel.text = service.title
        cell.cityLabel.text = service.city + ", " + service.state
        cell.descriptionLabel.text = service.description
        cell.distanceLabel.text = service.distanceMiles + " Mi"
        
        var price = service.price
        let index = price.characters.indexOf(".")
        
        if price != "" && index != nil {
            price = price.substringToIndex(index!)
        }
        
        cell.priceLabel.text = "$" + price
        
        cell.setImageTo("defaultServiceImage")
        
        
        if let image = service.image {
            cell.serviceImage.image = image
        }
        
        return cell
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showService" {
            
            let singleServiceViewController = segue.destinationViewController as! SingleServiceViewController
            
            if let selectedCell = sender as? ServiceTableViewCell {
                let indexPath = serviceTableView.indexPathForCell(selectedCell)
                let selectedService = self.services[indexPath!.row]
                
                singleServiceViewController.service = selectedService
            }
            
        }
    }

    

}
