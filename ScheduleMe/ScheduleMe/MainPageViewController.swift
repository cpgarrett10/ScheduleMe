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

class MainPageViewController : UIViewController {
    
    
    // firebase
    let ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    var dataSource: FirebaseTableViewDataSource!
    
    // props
    @IBOutlet weak var serviceTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceRef = self.ref.childByAppendingPath("services")
        
        
        self.dataSource = FirebaseTableViewDataSource(ref: serviceRef,
            modelClass: FDataSnapshot.self,
            cellClass: UITableViewCell.self,
            cellReuseIdentifier: "Cell",
            view: self.serviceTableView)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FDataSnapshot // Force cast to an FDataSnapshot
            /* Populate cell with contents of the snapshot */
            
            let title = snap.value.objectForKey("Title") as! String
            
            cell.textLabel?.text = title
            
        }
        
        self.serviceTableView.dataSource = self.dataSource
        
        
        
    }

    
    
    /* CARSONS CODE
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
