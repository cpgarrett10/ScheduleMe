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
    var kyleisawesome = ["FirstName":"Kyle", "LastName":"Tucker", "Email":"cpgarrett10@gmail.com"]
    

    
    
    @IBOutlet var FirstNameTxt: UITextField!
    @IBOutlet var LastNameTxt: UITextField!
    @IBOutlet var EmailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        /*
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.weatherCondition.text = snapshot.value as? String
            
        })
        */
    }
    
    /*
    @IBAction func updateWeatherButton(sender: UIButton) {
        ref.setValue(sender.titleLabel?.text)
        
    }
    */
    
    @IBAction func UpdateUserProfile(sender: AnyObject) {
        
        var usersRef = ref.childByAppendingPath("users")
        
        var users = ["kyleisawesome": kyleisawesome]

        usersRef.setValue(users)
        
        usersRef.childByAppendingPath("kyleisawesome").setValue(kyleisawesome)
        
        var kyleRef = usersRef.childByAppendingPath("kyleisawesome")
        var nickname = ["nickname": "Amazing Grace"]
        
        kyleRef.updateChildValues(nickname)
        
        
        usersRef.updateChildValues([
            "kyleisawesome/nickname": "Amazing Grace version 2",
            "kyleisawesome/FirstName": "Carson",
            "kyleisawesome/AdditionalFact": "Hawaii"
            ])
        
        /*
        ref.setValue(<#T##value: AnyObject?##AnyObject?#>, forKey: <#T##String#>)
        ref.setValue(<#T##value: AnyObject!##AnyObject!#>)
        
        ref.childByAppendingPath("users/cpgarrett10@gmail.com/name")
        */
    }
}