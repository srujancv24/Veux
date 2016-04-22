//
//  SignUpViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 2/24/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var uName: UITextField!
    @IBOutlet weak var UEmail: UITextField!
    @IBOutlet weak var uPassword: UITextField!
    @IBOutlet weak var uCPassword: UITextField!
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        
        let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
        let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
        let VERSION_NUM = "v1"
        
        let user: String
        uName.delegate = self
        UEmail.delegate = self
        uPassword.delegate = self
        uCPassword.delegate = self
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        if uName.hasText() && uPassword.hasText() && UEmail.hasText() && uCPassword.hasText(){
            print("All fields have text!")
            if uPassword.text == uCPassword.text {
                //The two fields are the exact same so we need to run the function now
                self .attemptSignUp()
            }else{
                let alert = UIAlertController(title: "Error", message: "Passwords Dont Match", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                //the two fields do not match
                print("The two password fields do not match");
            }
        } else if !uName.hasText(){
            let alert = UIAlertController(title: "Error", message: "Username is empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            print("Username is empty")
        } else if !UEmail.hasText() {
            let alert = UIAlertController(title: "Error", message: "Email is empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            print("Email is empty")
        } else if !uPassword.hasText() {
            let alert = UIAlertController(title: "Error", message: "Password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            print("Password is empty")
        } else if !uCPassword.hasText(){
            let alert = UIAlertController(title: "Error", message: "Confirm password is empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

            print("Confirm password is empty")
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
         self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func attemptSignUp()
    {
        print("Attempting sign up")
       Types.tryblock({ () -> Void in
            
            let user = BackendlessUser()
            
            
            //Set the property username for the locally created user
            user.setProperty("username", object: self.uName.text)
            
            //Set the property email for the locally created user
            user.email = self.UEmail.text
            
            //Set the property password for the locally created user
            user.password = self.uPassword.text
            
            //Now we need to sync this user with the Backendless server using thier cool nifty function
            let registeredUser = self.backendless.userService.registering(user)
            
            //If there is no errors then print the user details
            print("User has been registered (SYNC): \(registeredUser)")
        
            self.backendless.userService.setStayLoggedIn( true )
            
            //Now that the user is created, dismiss the current view controller.
            //can make segue to another scene add an alert view all sorts of stuff.
            self.dismissViewControllerAnimated(true, completion: {})
            },
            catchblock: { (exception) -> Void in
                //If there is an error we want to print that!
                print("Server reported an error: \(exception)" )
        })
    }
    
}