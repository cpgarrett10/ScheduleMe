//
//  UserProfileViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController : UIViewController {
    
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var serviceCounter = "-1"
    //var dataSource: FirebaseTableViewDataSource!
    
    @IBOutlet weak var updateButtonLabel: UIButton!
    @IBOutlet weak var editButtonLabel: UIButton!
    @IBOutlet var FirstNameTxt: UITextField!
    @IBOutlet var LastNameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    @IBOutlet var UserServicesTable: UITableView!
    
    @IBOutlet weak var profilePic: UIImageView!
    //var kyleisawesome = ["FirstName": "Kyle" , "LastName":"Tucker", "Email":"cpgarrett10@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use round profile pic
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2.0
        
        
        updateButtonLabel.backgroundColor = UIColor.clearColor()
        updateButtonLabel.layer.cornerRadius = 5
        updateButtonLabel.layer.borderWidth = 1
        updateButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        editButtonLabel.backgroundColor = UIColor.clearColor()
        editButtonLabel.layer.cornerRadius = 5
        editButtonLabel.layer.borderWidth = 1
        editButtonLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        //let servicesRef = ref.childByAppendingPath("services")
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            
            //Pull in Name & Email from Firebase
            self.FirstNameTxt.text = snapshot.value.objectForKey("FirstName") as? String
            self.LastNameTxt.text = snapshot.value.objectForKey("LastName") as? String
            self.EmailTxt.text = snapshot.value.objectForKey("email") as? String
            
            //Print what our counter is at
            print(snapshot.value)
            print(snapshot.value.objectForKey("ServiceCounter") as? String)
            let result = snapshot.value.objectForKey("ServiceCounter") as? String
            print(result)
            print(self.serviceCounter)
            
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
        print(self.serviceCounter)
        
        /*
        self.dataSource = FirebaseTableViewDataSource(ref: servicesRef, cellReuseIdentifier: "Cell", view: self.UserServicesTable)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
        let snap = obj as! FDataSnapshot
        
        // Populate cell as you see fit, like as below
        cell.textLabel?.text = snap.key as String
        }
        
        self.UserServicesTable.dataSource = self.dataSource
        */
        
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
            destinationViewController.serviceID = ""
        }
    }
}