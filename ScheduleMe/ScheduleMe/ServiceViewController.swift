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
    var serviceCounter: String = ""
    var AddEdit: String = ""
    var serviceID: String = ""
    
    @IBOutlet var descriptionTextView: UITextView!
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
    @IBOutlet var ServiceImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5
        
        //let servicesCounter = servicesCounterFunc()
        let servicesRef = ref.childByAppendingPath("services")
        let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
        
        //DO AN IF STATEMENT TO CHECK IF ALL FIELDS EXIST, IF NOT CREATE THEM THEN UPDATE THEM, OTHERWISE UPDATE THEM
        
        //IF ServiceExists Then use the corresponding number ELSE Use the next value in the counter- Therefore use a number
        
        // USE ONLY ON UPDATING A SERVICE
        servicesIDRef.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.TitleTxt.text = snapshot.value.objectForKey("Title") as? String
            self.TypeTxt.text = snapshot.value.objectForKey("Type") as? String
            self.SrvcEmailTxt.text = snapshot.value.objectForKey("ServiceEmail") as? String
            self.PhoneTxt.text = snapshot.value.objectForKey("Phone") as? String
            self.PriceTxt.text = snapshot.value.objectForKey("Price") as? String
            self.StreetAddressTxt.text = snapshot.value.objectForKey("StreetAddress") as? String
            self.CityTxt.text = snapshot.value.objectForKey("City") as? String
            self.StateTxt.text = snapshot.value.objectForKey("State") as? String
            self.ZipTxt.text = snapshot.value.objectForKey("Zip") as? String
            self.DistanceMilesTxt.text = snapshot.value.objectForKey("DistanceMiles") as? String
            self.descriptionTextView.text = snapshot.value.objectForKey("Description") as? String
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
    }
    
    @IBAction func AddUpdateServiceBtn(sender: AnyObject) {
        
        let servicesRef = ref.childByAppendingPath("services")
        let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
        
        
        servicesIDRef.updateChildValues([
            "Title": TitleTxt.text!,
            "Type": TypeTxt.text!,
            "ServiceEmail": SrvcEmailTxt.text!,
            "Phone": PhoneTxt.text!,
            "Price": PriceTxt.text!,
            "StreetAddress": StreetAddressTxt.text!,
            "City": CityTxt.text!,
            "State": StateTxt.text!,
            "Zip": ZipTxt.text!,
            "DistanceMiles": DistanceMilesTxt.text!,
            "Description": descriptionTextView.text!,
            "uid": uid!
            
            ])
        
        if AddEdit == "Add" {
            let usersRef = ref.childByAppendingPath("users")
            let userIDRef = usersRef.childByAppendingPath(uid)
            
            userIDRef.updateChildValues([
                "ServiceCounter": (Int(self.serviceCounter)! + 1)
                ])
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CancelSegue") {
            
            if AddEdit == "Add" {
                let servicesRef = ref.childByAppendingPath("services")
                let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
                
                print(servicesIDRef)
                
                //servicesIDRef.removeValue() NEED TO FIX
            }
        }
    }
}