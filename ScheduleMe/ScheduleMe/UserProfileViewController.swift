//
//  UserProfileViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class UserProfileViewController : UIViewController {
    
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    
    @IBOutlet var FirstNameTxt: UITextField!
    @IBOutlet var LastNameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    
    //var kyleisawesome = ["FirstName": "Kyle" , "LastName":"Tucker", "Email":"cpgarrett10@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.FirstNameTxt.text = snapshot.value.objectForKey("FirstName") as? String
            self.LastNameTxt.text = snapshot.value.objectForKey("LastName") as? String
            self.EmailTxt.text = snapshot.value.objectForKey("email") as? String
            }, withCancelBlock: { error in
                print(error.description)
        })

    }
    
    @IBAction func UpdateUserProfile(sender: AnyObject) {
        
        //DO AN IF STATEMENT TO CHECK IF ALL FIELDS EXIST, IF NOT CREATE THEM THEN UPDATE THEM, OTHERWISE UPDATE THEM
        
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
}