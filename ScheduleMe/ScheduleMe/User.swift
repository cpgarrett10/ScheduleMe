//
//  User.swift
//  ScheduleMe
//
//  Created by Dan Morain on 3/28/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase

class User {
    
    // MARK: Properties
    
    // firebase
    let key: String!
    let ref: Firebase?

    // FirstName, LastName, ServiceCounter, Type, email, profileImage, provider
    let uid: String
    let fname: String
    let lname: String
    let email: String
    let image: UIImage?
    
    
    // MARK: Initializers
    init(key: String = "",
         uid: String,
         fname: String,
         lname: String,
         email: String,
         image: UIImage) {
        
        self.key = key
        self.ref = nil
        self.uid = uid
        self.fname = fname
        self.lname = lname
        self.email = email
        self.image = image
        
    }
    
    init(snapshot: FDataSnapshot) {
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        self.uid = snapshot.value["City"] as! String
        self.fname = snapshot.value["City"] as! String
        self.lname = snapshot.value["City"] as! String
        self.email = snapshot.value["City"] as! String
        
        // get image string
        if let base64string = snapshot.value["Base64Image"] as? String {
            // convert to UIImage
            let decodedData = NSData(base64EncodedString: base64string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image = UIImage(data: decodedData)!
        } else {
            self.image = UIImage(named: "defaultProfileImage")
        }
        
        
    }
    
    
    
    // serviceCount get array of services and return size, not static value
    
    
}