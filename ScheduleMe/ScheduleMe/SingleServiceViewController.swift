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

class SingleServiceViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var serviceTitle: UINavigationBar!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceAddress: UILabel!
    @IBOutlet weak var serviceDescription: UITextView!
    @IBOutlet weak var serviceProviderName: UILabel!
    @IBOutlet weak var servicePhone: UILabel!
    @IBOutlet weak var serviceEmail: UILabel!
    @IBOutlet var profileIconImage: UIImageView!
    
    @IBOutlet weak var horizontalLine: UIView!
    
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var service: Service?
    var Profilebase64String: String = ""
    var ProfiledecodedData:NSData?
    var ProfiledecodedImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        initHorizontalLine()
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        if let service = service {
            initComponents(service)
        }
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            //Pull in Image from Firebase
            self.Profilebase64String = (snapshot.value.objectForKey("Base64Image") as? String)!
            self.ProfiledecodedData = NSData(base64EncodedString: self.Profilebase64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.ProfiledecodedImage = UIImage(data: self.ProfiledecodedData!)!
            
            self.profileIconImage.image = self.ProfiledecodedImage
            self.profileIconImage.contentMode = .ScaleAspectFill
            self.profileIconImage.layer.cornerRadius = self.profileIconImage.frame.size.width / 2;
            self.profileIconImage.clipsToBounds = true;        
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        profileIconImage.userInteractionEnabled = true
        profileIconImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func imageTapped(img: AnyObject)
    {
        //send them to home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("userProfile") as UIViewController
        self.presentViewController(MainPageViewController, animated: true, completion: nil)
    }
    
    func initHorizontalLine() {
        horizontalLine.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        horizontalLine.layer.borderWidth = 1.0
        horizontalLine.layer.cornerRadius = 5
    }
    
    func initComponents(service: Service) {
        serviceImage.image = service.image
        serviceTitle.topItem?.title = service.title
        servicePrice.text = "$" + service.price
        serviceAddress.text = service.streetAddress
        serviceDescription.text = service.description
        servicePhone.text = service.phone
        serviceEmail.text = service.serviceEmail
        
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
    
    // MARK: Action
    
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}