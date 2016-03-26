//
//  ServiceViewController.swift
//  ScheduleMe
//
//  Created by Kyle Tucker on 3/5/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class ServiceListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    var services = [Service]()
    
    @IBOutlet weak var serviceTableView: UITableView!
    
    // firebase
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        fetchServicesFromFirebase()
    }
    
    func fetchServicesFromFirebase() {
        let serviceRef = self.ref.childByAppendingPath("services")
        
        serviceRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newItems = [Service]()
            
            for item in snapshot.children {
                let service = Service(snapshot: item as! FDataSnapshot)
                newItems.append(service)
            }
            
            self.services = newItems
            
            self.serviceTableView.reloadData()
        })
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ServiceTableViewCell"
        
        let cell = serviceTableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ServiceTableViewCell
        
        let service = self.services[indexPath.row]
        
        cell.titleLabel.text = service.title
        cell.setImageTo("defaultServiceImage")
        
        
//        if let image = service.photo {
//            cell.serviceImage = image
//        }

        
        
        
        
        
        return cell
    }

    

}
