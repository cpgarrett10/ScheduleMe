//
//  Service.swift
//  
//
//  Created by Dan Morain on 3/26/16.
//
//

import Foundation
import Firebase

class Service {
    
    // MARK: Properties
    
    let key: String!
    let ref: Firebase?
    let title: String!
    let city: String!
    let description: String!
    let distanceMiles: String!
    let phone: String!
    let price: String!
    let serviceEmail: String!
    let state: String!
    let streetAddress: String!
    let type: String!
    let zip: String!
    let uid: String!
    
    let image: UIImage?
    
    // Initialize from arbitrary data
    init(title: String,
        key: String = "",
        city: String,
        description: String,
        distanceMiles: String,
        phone: String,
        price: String,
        serviceEmail: String,
        state: String,
        streetAddress: String,
        type: String,
        zip: String,
        uid: String,
        image: UIImage) {
            
        self.key = key
        self.ref = nil
        self.title = title
            
        self.city = city
        self.description = description
        self.distanceMiles = distanceMiles
        self.phone = phone
        self.price = price
        self.serviceEmail = serviceEmail
        self.state = state
        self.streetAddress = streetAddress
        self.type = type
        self.zip = zip
        self.uid = uid
            
        self.image = image
        
    }
    
    init(snapshot: FDataSnapshot) {
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        self.city = snapshot.value["City"] as! String
        self.description = snapshot.value["Description"] as! String
        self.distanceMiles = snapshot.value["DistanceMiles"] as! String
        self.phone = snapshot.value["Phone"] as! String
        self.price = snapshot.value["Price"] as! String
        self.serviceEmail = snapshot.value["ServiceEmail"] as! String
        self.state = snapshot.value["State"] as! String
        self.streetAddress = snapshot.value["StreetAddress"] as! String
        self.title = snapshot.value["Title"] as! String
        self.type = snapshot.value["Type"] as! String
        self.zip = snapshot.value["Zip"] as! String
        self.uid = snapshot.value["uid"] as! String
        
        // get image string
        if let base64string = snapshot.value["Base64Image"] as? String {
            // convert to UIImage
            let decodedData = NSData(base64EncodedString: base64string, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
            self.image = UIImage(data: decodedData)!
        } else {
            self.image = UIImage(named: "defaultServiceImage")
        }

        
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "city": self.city,
            "description": self.description,
            "distanceMiles": self.distanceMiles,
            "phone": self.phone,
            "price": self.price,
            "serviceEmail": self.serviceEmail,
            "state": self.state,
            "streetAddress": self.streetAddress,
            "title": self.title,
            "type": self.type,
            "zip": self.zip,
            "uid": self.uid
        ]
    }
    
    func fullAddress() -> String {
        return streetAddress + ", " + city + ", " + state + " " + zip
    }
}