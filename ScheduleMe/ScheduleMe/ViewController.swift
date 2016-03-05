//
//  ViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 2/20/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var login = false
    
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var loginSignUp: UIButton!
    @IBOutlet var switchLoginSceen: UIButton!
    
    @IBOutlet var weatherCondition: UILabel!
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")

    @IBAction func SignUp(sender: AnyObject) {
        
        
        if self.login == false {
            
            login = true
            
            self.accountLabel.text = "Already have an account?"
            self.switchLoginSceen.setTitle("Login", forState: .Normal)
            self.loginSignUp.setTitle("Sign Up", forState: .Normal)
            
        } else {
            
            login = false
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("Login", forState: .Normal)
        
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ref.observeEventType(.Value, withBlock: {
            snapshot in
            self.weatherCondition.text = snapshot.value as? String
            
            
            
            
            
            
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

