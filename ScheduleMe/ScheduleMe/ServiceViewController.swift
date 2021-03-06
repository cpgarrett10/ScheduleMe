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
    
    // MARK: Properties
    
    var service: Service?
    
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
    var Profilebase64String: String = ""
    var ProfiledecodedData:NSData?
    var ProfiledecodedImage:UIImage?
    var userIDRef:String?
    
    @IBOutlet var profileIconImage: UIImageView!
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
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DistanceMilesTxt.hidden = true
        let usersRef = ref.childByAppendingPath("users")
        let userIDRef = usersRef.childByAppendingPath(uid)
        initComponents()
        setLabelValues()
        
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
    
    func initComponents() {
        // use round photo
        ServiceImg.layer.cornerRadius = ServiceImg.frame.size.width / 2.0
        ServiceImg.clipsToBounds = true
        
        addServiceButtonLabel.backgroundColor = UIColor.clearColor()
        addServiceButtonLabel.layer.cornerRadius = 5
        addServiceButtonLabel.layer.borderWidth = 1
        addServiceButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        
        if AddEdit == "Edit" {
            addServiceButtonLabel.setTitle("Update Service", forState: UIControlState.Normal)
        }
        
        commuteButtonLabel.layer.borderColor = UIColor(red: 153/255, green: 204/255, blue: 238/255, alpha: 1).CGColor
        
        descriptionTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5
        
        self.DistanceMilesTxt.hidden = true
        
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // tap to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func setLabelValues() {
        if AddEdit == "Edit" {
            self.TitleTxt.text = self.service?.title
            self.TypeTxt.text = self.service?.type
            self.SrvcEmailTxt.text = service?.serviceEmail
            self.PhoneTxt.text = self.service?.phone
            self.PriceTxt.text = service?.price
            self.StreetAddressTxt.text = service?.streetAddress
            self.CityTxt.text = service?.city
            self.StateTxt.text = service?.state
            self.ZipTxt.text = service?.zip
            self.DistanceMilesTxt.text = service?.distanceMiles
            self.descriptionTextView.text = service?.description
            self.serviceImage.image = service?.image
            
            self.serviceImageTEMP = service?.image
            
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
    
    
    // MARK: UITextField Helpers
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageTapped(img: AnyObject)
    {
        //send them to home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("userProfile") as UIViewController
        self.presentViewController(MainPageViewController, animated: true, completion: nil)
        // if cancel, dismiss
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.serviceImageTEMP = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.serviceImage.image = self.serviceImageTEMP
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Actions
    
    
    @IBAction func AddUpdateServiceBtn(sender: AnyObject) {
        let servicesRef = ref.childByAppendingPath("services")
        let servicesIDRef = servicesRef.childByAppendingPath(serviceID)
        
        let imageData: NSData = UIImageJPEGRepresentation(serviceImageTEMP!, 0.1)!
        let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        print(TitleTxt.text)
        
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
    
}