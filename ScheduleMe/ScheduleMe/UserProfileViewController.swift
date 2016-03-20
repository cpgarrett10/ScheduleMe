//
//  UserProfileViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit


class UserProfileViewController : UIViewController {
    
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var serviceCounter = "-1"
    //var dataSource: FirebaseTableViewDataSource!
    
    @IBOutlet var FirstNameTxt: UITextField!
    @IBOutlet var LastNameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    @IBOutlet var UserServicesTable: UITableView!
    
    //var kyleisawesome = ["FirstName": "Kyle" , "LastName":"Tucker", "Email":"cpgarrett10@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        //let servicesRef = ref.childByAppendingPath("services")
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.FirstNameTxt.text = snapshot.value.objectForKey("FirstName") as? String
            self.LastNameTxt.text = snapshot.value.objectForKey("LastName") as? String
            self.EmailTxt.text = snapshot.value.objectForKey("email") as? String
            
            print(snapshot.value.objectForKey("ServiceCounter") as? String)
            let result = snapshot.value.objectForKey("ServiceCounter") as? String
            
            if result != nil {
                self.serviceCounter = result!
            } else {
                self.serviceCounter = "0"
                userIDRef.updateChildValues([
                    "ServiceCounter": self.serviceCounter
                    ])
            }
            
            print(result)
            print(self.serviceCounter)
            print(snapshot.value.objectForKey("ServiceCounter") as? String)
            
            }, withCancelBlock: { error in
                print(error.description)
        })
        
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
            
            let servicesRef = ref.childByAppendingPath("services")
            let servicesIDRef = servicesRef.childByAppendingPath("\(uid)Service\(serviceCounter)")
            
            //Create a Service with the proper USERID
            servicesIDRef.updateChildValues([
                "uid": uid!
                ])
            
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