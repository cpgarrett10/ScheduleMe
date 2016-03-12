//
//  ViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 2/20/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    
    var login = 1 //Login = 1 SignUp = 2 ForgotPassword = 3
    
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var loginSignUp: UIButton!
    @IBOutlet var switchLoginSceen: UIButton!
    @IBOutlet var UsernameTxt: UITextField!
    @IBOutlet var PasswordTxt: UITextField!
    @IBOutlet var weatherCondition: UILabel!
    @IBOutlet var ForgotPassButton: UIButton!
    
    
    @IBAction func forgotPassClick(sender: AnyObject) {
        
        login = 3
        
        self.accountLabel.text = "Know you password?"
        self.switchLoginSceen.setTitle("Login", forState: .Normal)
        self.loginSignUp.setTitle("Submit", forState: .Normal)
        self.PasswordTxt.hidden = true
        self.UsernameTxt.text = ""
        self.PasswordTxt.text = ""
        self.ForgotPassButton.hidden = true
        
    }
    
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")

    @IBAction func SignUp(sender: AnyObject) {
        
        if self.login == 1 {
            
            login = 2
            
            self.accountLabel.text = "Already have an account?"
            self.switchLoginSceen.setTitle("Login", forState: .Normal)
            self.loginSignUp.setTitle("Sign Up", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = true
            
            
        } else if self.login == 2 {
            
            login = 1
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("Login", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = false
        
        } else if self.login == 3 {
        
            login = 1
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("Login", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = false
        
        }
    
    }
    
    @IBAction func loginSignUp(sender: AnyObject) {
    
        if self.login == 1 {
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
                        
                        let uid = self.ref.authData.uid
                        print("Here is the uID that you can use everywhere: \(uid)")
                    }
            })
            
            
        } else if self.login == 2 {
            
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
            
        } else if self.login == 3 {
            
            // Enter Pass reset logic here
            
            ref.resetPasswordForUser(UsernameTxt.text, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                } else {
                    
                    // Password reset sent successfully
                    print("Password reset sent successfully")
                }
            })
            
            print("I am going to reset my password")
            
            //LET USER KNOW THEY HAVE A PASSWORD RESET EMAIL WAITING
            
            login = 1
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("Login", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = false
            
            
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
      //self.gradientView.initGradient()
    
        
        
        

        
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

