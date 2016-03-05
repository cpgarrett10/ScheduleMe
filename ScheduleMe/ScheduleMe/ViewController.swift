//
//  ViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 2/20/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    var login:Int = 1
    @IBOutlet var accountLabel: UILabel!
    
    @IBOutlet var weatherCondition: UILabel!
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")

    @IBAction func SignUp(sender: AnyObject) {
        login = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.weatherCondition.text = snapshot.value as? String
            
            
            
            if self.login == 1 {
                
                self.accountLabel.text = "Already have an account?"
                
            }
            
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    @IBAction func updateWeatherButton(sender: UIButton) {
        ref.setValue(sender.titleLabel?.text)
        
    }
}

