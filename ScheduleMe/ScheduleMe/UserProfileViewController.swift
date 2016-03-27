//
//  UserProfileViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var services = [Service]()
    
    // firebase
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var serviceCounter = "-1"

    // handle image decoding/encoding
    var base64String: String = ""
    var decodedData:NSData?
    var decodedImage:UIImage?
    
    // UI components
    @IBOutlet weak var updateButtonLabel: UIButton!
    @IBOutlet var editButtonLabel: UIButton!
    @IBOutlet var FirstNameTxt: UITextField!
    @IBOutlet var LastNameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var editTableViewButton: UIBarButtonItem!
    
    //var kyleisawesome = ["FirstName": "Kyle" , "LastName":"Tucker", "Email":"cpgarrett10@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
        initUserFields()
        
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        fetchServicesFromFirebase()
    }
    
    func initComponents() {
        // use round profile pic
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2.0
        
        updateButtonLabel.backgroundColor = UIColor.clearColor()
        updateButtonLabel.layer.cornerRadius = 5
        updateButtonLabel.layer.borderWidth = 1
        updateButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        editButtonLabel.backgroundColor = UIColor.clearColor()
        editButtonLabel.layer.cornerRadius = 5
        editButtonLabel.layer.borderWidth = 1
        editButtonLabel.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func initUserFields() {
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        //let servicesRef = ref.childByAppendingPath("services")
        //let imageUrl = ref.authData.providerData["profileImageURL"]
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            
            //Pull in Name & Email from Firebase
            self.FirstNameTxt.text = snapshot.value.objectForKey("FirstName") as? String
            self.LastNameTxt.text = snapshot.value.objectForKey("LastName") as? String
            self.EmailTxt.text = snapshot.value.objectForKey("email") as? String
            self.base64String = (snapshot.value.objectForKey("profileImage") as? String)!
            
            self.decodedData = NSData(base64EncodedString: self.base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.decodedImage = UIImage(data: self.decodedData!)!
            self.profileImage.image = self.decodedImage
            
            let result = snapshot.value.objectForKey("ServiceCounter") as? String
            //If counter != null then pull it, if == null then create it as 0
            if result != nil {
                self.serviceCounter = result!
            } else {
                self.serviceCounter = "0"
                userIDRef.updateChildValues([
                    "ServiceCounter": self.serviceCounter
                    ])
            }
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    func fetchServicesFromFirebase() {
        let serviceRef = ref.childByAppendingPath("services")
        
        serviceRef.queryOrderedByChild("uid").queryEqualToValue(self.uid)
            .observeEventType(.Value, withBlock: { snapshot in
            
                var newItems = [Service]()
                
                for item in snapshot.children {
                    let service = Service(snapshot: item as! FDataSnapshot)
                    newItems.append(service)
                }
                
                self.services = newItems
                self.serviceTableView.reloadData()
            })
    }
    
    
    // MARK: UITableViewControllerDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UserServiceTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserServiceTableViewCell
        
        let service = services[indexPath.row]
        
        cell.titleLabel.text = service.title
        cell.cityLabel.text = service.city
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            
            
            
            // delete from firebase
            let service = services[indexPath.row]
            service.ref?.removeValue()
            
            // delete from array
            services.removeAtIndex(indexPath.row)
            
            // delete from tableView
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (self.serviceTableView.editing) {
            return UITableViewCellEditingStyle.Delete
        }
        return UITableViewCellEditingStyle.None
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // if cancel, dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData: NSData = UIImageJPEGRepresentation(selectedImage, 0.1)!
        let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //Prep to set FirebaseImage
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        userIDRef.updateChildValues([
            "profileImage": base64String
            ])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        if (self.serviceTableView.editing) {
            editTableViewButton.title = "Edit"
            self.serviceTableView.setEditing(false, animated: true)
        } else {
            editTableViewButton.title = "Done"
            self.serviceTableView.setEditing(true, animated: true)
        }
        
    }
    
    
    @IBAction func UpdateUserProfile(sender: AnyObject) {
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        //let nickname = ["nickname": "Amazing Grace"]
        
        userIDRef.updateChildValues([
            "FirstName": FirstNameTxt.text!,
            "LastName": LastNameTxt.text!
            ])
        
        
        //kyleRef.updateChildValues(nickname)
        
        /* KEEP THIS FOR FUTURE USE
        usersRef.updateChildValues([
        "kyleisawesome/nickname": "Amazing Grace version 2",
        "kyleisawesome/FirstName": FirstNameTxt.text!,
        "kyleisawesome/LastName": LastNameTxt.text!,
        "kyleisawesome/AdditionalFact": "Hawaii"
        ], withCompletionBlock: {
        (error:NSError?, ref:Firebase!) in
        if (error != nil) {
        print("Data could not be saved.")
        } else {
        print("Data saved successfully!")
        }
        })
        */
    }
    
    @IBAction func editProfileImage(sender: AnyObject) {
        
            let imagePickerController = UIImagePickerController()
            
            // only allow pictures to be selected, not taken (use to .Camera to take photo)
            imagePickerController.sourceType = .PhotoLibrary
            
            imagePickerController.delegate = self
            
            // show image picker
            self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "AddServiceSegue") {
            
            let destinationViewController = segue.destinationViewController as! ServiceViewController
            destinationViewController.serviceCounter = self.serviceCounter
            destinationViewController.AddEdit = "Add"
            destinationViewController.serviceID = "\(uid)Service\(self.serviceCounter)"
        }
        
        if (segue.identifier == "EditServiceSegue") {
            let destinationViewController = segue.destinationViewController as! ServiceViewController
            destinationViewController.AddEdit = "Edit"
            
            
            
            if let selectedCell = sender as? UserServiceTableViewCell {
                let indexPath = serviceTableView.indexPathForCell(selectedCell)
                let selectedService = self.services[indexPath!.row]
                
                destinationViewController.service = selectedService
                destinationViewController.serviceID = selectedService.key
            }
            
        }
    }
}