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

    
    
 /*   override func viewDidLoad() {
       super.viewDidLoad()

        // 1
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            // 2
            var newItems = [String]()
            
            // 3
            for item in snapshot.children {
                newItems.append(item.value)
            }
            
            print(newItems)
            
            // 5
//            self.items = newItems
//            self.tableView.reloadData()
        })
    
    
    }
*/
}
