//
//  ViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 2/20/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var login = true
    
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var loginSignUp: UIButton!
    @IBOutlet var switchLoginSceen: UIButton!
    @IBOutlet var UsernameTxt: UITextField!
    @IBOutlet var PasswordTxt: UITextField!
    @IBOutlet var weatherCondition: UILabel!
    
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")

    @IBAction func SignUp(sender: AnyObject) {
        
        if self.login == true {
            
            login = false
            
            self.accountLabel.text = "Already have an account?"
            self.switchLoginSceen.setTitle("Login", forState: .Normal)
            self.loginSignUp.setTitle("Sign Up", forState: .Normal)
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            
        } else {
            
            login = true
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("Login", forState: .Normal)
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
        
        }
    
    }
    
    @IBAction func loginSignUp(sender: AnyObject) {
    
        if self.login == true {
            //Login logic
            ref.authUser(UsernameTxt.text, password: PasswordTxt.text,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        // There was an error logging in to this account
                        
                        print("You have failed to loggin" + error.debugDescription)
                    } else {
                        // We are now logged in
                        print("You have successfully logged in")
                        
                        //send them to home screen
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let serviceViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("serviceView") as UIViewController
                        self.presentViewController(serviceViewController, animated: true, completion: nil)
                    }
            })
            
            
        } else {
            
            ref.createUser(UsernameTxt.text, password: PasswordTxt.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        // There was an error creating the account
                        print("This account already exists " + error.debugDescription)
                        
                    } else {
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        //send them to first time experience
                        
                    }
            })
            //sign up logic
            
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

