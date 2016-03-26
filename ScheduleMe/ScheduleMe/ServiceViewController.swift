//
//  ServiceViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase

class ServiceViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    let uid = Firebase(url: "https://schedulemecapstone.firebaseio.com/").authData.uid
    var serviceCounter: String = ""
    var AddEdit: String = ""
    var serviceID: String = ""
    var serviceBoolean = true
    var base64Image: String = ""
    var decodedData:NSData?
    var decodedImage:UIImage?
    var serviceImageTEMP:UIImage?
    
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
    @IBOutlet weak var addServiceButtonLabel: UIButton!
    @IBOutlet weak var commuteButtonLabel: UIButton!
    @IBOutlet var editServiceImage: UIButton!
    @IBOutlet var serviceImage: UIImageView!
    
    
    //From Dan for editing/dismissing image on edit image action
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        // if cancel, dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.serviceImageTEMP = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.serviceImage.image = self.serviceImageTEMP
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.DistanceMilesTxt.hidden = true
        
        
        // use round photo
        ServiceImg.layer.cornerRadius = ServiceImg.frame.size.width / 2.0
        
        
        addServiceButtonLabel.backgroundColor = UIColor.clearColor()
        addServiceButtonLabel.layer.cornerRadius = 5
        addServiceButtonLabel.layer.borderWidth = 1
        addServiceButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        commuteButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5

        let servicesRef = ref.childByAppendingPath("services")
        let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
        
 
        
        if AddEdit == "Edit" {
        // USE ONLY ON UPDATING A SERVICE
            servicesIDRef.observeEventType(.Value, withBlock: { snapshot in
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
                
                //load current image
                self.base64Image = (snapshot.value.objectForKey("Base64Image") as? String)!
                self.decodedData = NSData(base64EncodedString: self.base64Image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                self.decodedImage = UIImage(data: self.decodedData!)!
                self.serviceImage.image = self.decodedImage
                
                }, withCancelBlock: { error in
                print(error.description)
            })
        } else {
            self.TitleTxt.text = ""
            self.TypeTxt.text = ""
            self.SrvcEmailTxt.text = ""
            self.PhoneTxt.text = ""
            self.PriceTxt.text = ""
            self.StreetAddressTxt.text = ""
            self.CityTxt.text = ""
            self.StateTxt.text = ""
            self.ZipTxt.text = ""
            self.DistanceMilesTxt.text = ""
            self.descriptionTextView.text = ""
            serviceImage.image = UIImage(named: "defaultServiceImage")
        }
        
    }
    
    @IBAction func AddUpdateServiceBtn(sender: AnyObject) {
        let servicesRef = ref.childByAppendingPath("services")
        let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
        
        let imageData: NSData = UIImageJPEGRepresentation(serviceImageTEMP!, 0.1)!
        let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        //Create/Update Service with the all details
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
            "uid": uid!,
            "Base64Image": base64String
            
            ])
        
        if AddEdit == "Add" {
            
            //Create Path to update ServiceID Counter
            let usersRef = ref.childByAppendingPath("users")
            let userIDRef = usersRef.childByAppendingPath(uid)
            
            //Update ServiceID Counter
            userIDRef.updateChildValues([
                "ServiceCounter": String((Int(self.serviceCounter)! + 1))
                ])
        }
        
    }
    
    @IBAction func commuteButton(sender: AnyObject) {
        if serviceBoolean == true{
            self.DistanceMilesTxt.hidden = false
            serviceBoolean = false
        }else{
            self.DistanceMilesTxt.hidden = true
            serviceBoolean = true
        }
    }
    
    @IBAction func editServiceImage(sender: AnyObject) {
        let imagePickerController = UIImagePickerController()
        
        // only allow pictures to be selected, not taken (use to .Camera to take photo)
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        
        // show image picker
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CancelSegue") {
            
            if AddEdit == "Add" {
                let servicesRef = ref.childByAppendingPath("services")
                let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
                
                //servicesIDRef.removeValue() NEED TO FIX
            }
        }
    }
}