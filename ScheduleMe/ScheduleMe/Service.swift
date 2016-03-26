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
    let title: String!
    let ref: Firebase?
    
    // Initialize from arbitrary data
    init(title: String, key: String = "") {
        self.key = key
        self.title = title
        self.ref = nil
    }
    
    init(snapshot: FDataSnapshot) {
        self.key = snapshot.key
        self.title = snapshot.value["Title"] as! String
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "title": self.title
        ]
    }
}