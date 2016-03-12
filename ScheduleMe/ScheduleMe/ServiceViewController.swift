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
    
/*
    self.dataSource = FirebaseTableViewDataSource(ref: ref,
    modelClass: FDataSnapshot.self,
    cellClass: UITableViewCell.self,
    cellReuseIdentifier: "<YOUR-REUSE-IDENTIFIER>",
    view: self.tableView)
    
    self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
    let snap = obj as! FDataSnapshot // Force cast to an FDataSnapshot
    /* Populate cell with contents of the snapshot */
    }
    
    self.tableView.dataSource = self.dataSource
    
    
    
    
   override func viewDidLoad() {
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
