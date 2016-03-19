//
//  ServiceViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ServiceViewController : UIViewController {
    
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid

    @IBOutlet var TitleTxt: UITextField!
    @IBOutlet var TypeTxt: UITextField!
    @IBOutlet var SrvcEmailTxt: UITextField!
    @IBOutlet var PhoneTxt: UITextField!
    @IBOutlet var PriceTxt: UITextField!
    @IBOutlet var StreetAddressTxt: UITextField!
    @IBOutlet var CityTxt: UITextField!
    @IBOutlet var StateTxt: UITextField!
    @IBOutlet var ZipTxt: UITextField!
    @IBOutlet var DistanceMilesTxt: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        
        //DO AN IF STATEMENT TO CHECK IF ALL FIELDS EXIST, IF NOT CREATE THEM THEN UPDATE THEM, OTHERWISE UPDATE THEM
        
        userIDRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.TitleTxt.text = snapshot.value.objectForKey("Title") as? String
            self.TypeTxt.text = snapshot.value.objectForKey("Type") as? String
            self.SrvcEmailTxt.text = snapshot.value.objectForKey("SrvcEmail") as? String
            }, withCancelBlock: { error in
                print(error.description)
        })
            
    }
        
    @IBAction func AddUpdateServiceBtn(sender: AnyObject) {
        
        //DO AN IF STATEMENT TO CHECK IF ALL FIELDS EXIST, IF NOT CREATE THEM THEN UPDATE THEM, OTHERWISE UPDATE THEM
        
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        //let nickname = ["nickname": "Amazing Grace"]
        
        userIDRef.updateChildValues([
            "Title": TitleTxt.text!,
            "Type": TypeTxt.text!,
            "SrvcEmail": SrvcEmailTxt.text!
            ])
        
    }
}
