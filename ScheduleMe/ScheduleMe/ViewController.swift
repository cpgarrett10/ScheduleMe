//
//  ViewController.swift
//  ScheduleMe
//
//  Created by Carson Garrett on 2/20/16.
//  Copyright © 2016 Carson Garrett. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    // MARK: Properties
    
    var login = 1 //Login = 1 SignUp = 2 ForgotPassword = 3
    
    @IBOutlet var scheduleMeLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var loginSignUp: UIButton!
    @IBOutlet var switchLoginSceen: UIButton!
    @IBOutlet var UsernameTxt: UITextField!
    @IBOutlet var PasswordTxt: UITextField!
    @IBOutlet var ForgotPassButton: UIButton!
    var defaultProfileImage = UIImage(named: "defaultProfileImage")!
    
    // firebase
    var ref = Firebase(url: "https://schedulemecapstone.firebaseio.com/")
    
    // MARK: Actions
    
    @IBAction func forgotPassClick(sender: AnyObject) {
        
        login = 3
        
        self.accountLabel.text = "Know you password?"
        self.switchLoginSceen.setTitle("Login", forState: .Normal)
        self.loginSignUp.setTitle("SUBMIT", forState: .Normal)
        self.PasswordTxt.hidden = true
        self.UsernameTxt.text = ""
        self.PasswordTxt.text = ""
        self.ForgotPassButton.hidden = true
        
    }
    
    

    @IBAction func SignUp(sender: AnyObject) {
        
        if self.login == 1 {
            
            login = 2
            
            self.accountLabel.text = "Already have an account?"
            self.switchLoginSceen.setTitle("Login", forState: .Normal)
            self.loginSignUp.setTitle("SIGN UP", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = true
            
            
        } else if self.login == 2 {
            
            login = 1
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("LOGIN", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = false
        
        } else if self.login == 3 {
        
            login = 1
            
            self.accountLabel.text = "Don't have an account?"
            self.switchLoginSceen.setTitle("Sign Up", forState: .Normal)
            self.loginSignUp.setTitle("LOGIN", forState: .Normal)
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
                        // an error occurred while attempting login
                        if let errorCode = FAuthenticationError(rawValue: error.code) {
                            switch (errorCode) {
                            case .UserDoesNotExist:
                                print("Handle invalid user")
                            case .InvalidEmail:
                                print("Handle invalid email")
                            case .InvalidPassword:
                                print("Handle invalid password")
                            default:
                                print("Handle default situation")
                            }
                        }
                        
                        print("You have failed to log in" + error.debugDescription)
                    
                    } else {
                        
//                        let uid = self.ref.authData.uid
                        
                        // We are now logged in
                        
                        //send them to home screen
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("transView") as UIViewController
                        self.presentViewController(MainPageViewController, animated: true, completion: nil)
                        
                    }
            })
            
            
        } else if self.login == 2 {
            //sign up logic
            
            ref.createUser(UsernameTxt.text, password: PasswordTxt.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        // There was an error creating the account
                        print("This account already exists " + error.debugDescription)
                        
                    } else {
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        //Log user in -- turn thi sinto a function
                        
                        self.ref.authUser(self.UsernameTxt.text, password: self.PasswordTxt.text,
                            withCompletionBlock: { error, authData in
                                if error != nil {
                                    // an error occurred while attempting login
                                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                                        switch (errorCode) {
                                        case .UserDoesNotExist:
                                            print("Handle invalid user")
                                        case .InvalidEmail:
                                            print("Handle invalid email") 
                                        case .InvalidPassword:
                                            print("Handle invalid password")
                                        default:
                                            print("Handle default situation")
                                        }
                                    }
                                    
                                    print("You have failed to log in" + error.debugDescription)
                                    
                                } else {
                                    
//                                    let uid = self.ref.authData.uid
                                    let imageData: NSData = UIImageJPEGRepresentation(self.defaultProfileImage, 0.1)!
                                    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

                                    
                                    //create new user dictionary
                                    let newUser = [
                                        "provider": authData.provider,
                                        "email": authData.providerData["email"] as? NSString as? String,
                                        "Base64Image": base64String
                                        
                                    ]
                                    
                                    //send dictionary to actaully create a new user in users in Firebase
                                    self.ref.childByAppendingPath("users").childByAppendingPath(authData.uid).setValue(newUser)
                                    
                                    //send them to home screen
                                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                    let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("transView") as UIViewController
                                    self.presentViewController(MainPageViewController, animated: true, completion: nil)
                                }
                        })                        
                    }
            })
            
            
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
            self.loginSignUp.setTitle("LOGIN", forState: .Normal)
            self.PasswordTxt.hidden = false
            self.UsernameTxt.text = ""
            self.PasswordTxt.text = ""
            self.ForgotPassButton.hidden = false
            
            
        }
    
    }
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gradientView.initGradient()
        initComponents()

    }
    
    override func viewDidAppear(animated: Bool) {
        // check if authenticated
        if ref.authData != nil {
            //send them to home screen
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let MainPageViewController : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("transView") as UIViewController
            self.presentViewController(MainPageViewController, animated: true, completion: nil)
        }
    }
    
    func initComponents() {
        // login button
        loginSignUp.backgroundColor = UIColor.clearColor()
        loginSignUp.layer.cornerRadius = 5
        loginSignUp.layer.borderWidth = 1
        loginSignUp.layer.borderColor = UIColor.whiteColor().CGColor
        
        // logo
        scheduleMeLabel.backgroundColor = UIColor.clearColor()
        scheduleMeLabel.layer.cornerRadius = 5
        scheduleMeLabel.layer.borderWidth = 3
        scheduleMeLabel.layer.borderColor = UIColor.whiteColor().CGColor
        
        // tap to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: UITextField Helpers
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}

