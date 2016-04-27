//
//  ViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 2/24/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var UserEmail: UITextField!
    @IBOutlet weak var UserPassword: UITextField!
    
    var backendless = Backendless.sharedInstance()

    override func viewDidLoad() {
        
        let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
        let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
        let VERSION_NUM = "v1"
        
        UserEmail.delegate=self
        UserPassword.delegate=self
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        super.viewDidLoad()
        
        self.validUserToken()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func fb(sender: UIButton) {
          self.easyFacebookLogin()
            }
    
    
    func easyFacebookLogin() {
        backendless.userService.easyLoginWithFacebookFieldsMapping(
            ["email":"email","id":"facebookId","name" : "name",
                "first_name": "first_name",
                "last_name" : "last_name",
                "gender": "gender"],
            permissions: ["public_profile", "email", "user_friends"],
            response: {(result : NSNumber!) -> () in
                print ("Result: \(result)")
            },
            error: { (fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
                
        })
    }

    
    @IBAction func loginButton(sender: AnyObject) {
        
       
            print("This is the username text", UserEmail.text)
            print("This is the password text", UserPassword.text)
            
            backendless.userService.login(
                UserEmail.text, password:UserPassword.text,
                response: { ( user : BackendlessUser!) -> () in
                    print("User has been logged in")
                    self.backendless.userService.setStayLoggedIn( true )
                   self.performSegueWithIdentifier("Login", sender: self)

                },
                error: { ( fault : Fault!) -> () in
                   
                    let alert = UIAlertController(title: "Invalid Details", message: "Server reported an error: \(fault)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            )
    }
    
    @IBAction func forgotPassword(sender: UIButton) {
        
        // Create the alertController
        //The alertController has two fiels that are on top of the alertController
        //The Title will be in bold and dierectly under that you will have your message.
        //You can make those say whatever you want but this is what I have chosen to go with
        let alertController = UIAlertController(title: "Forgot Password?",
            message: "Enter your username below to recieve an email with the new password",
            preferredStyle: .Alert)
        
        //Create the button action and name it
        //Changing the style will change the the color from default blue to a red cancel button
        let defaultAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        //Add the button to the alertController
        alertController.addAction(defaultAction)
        
        //Add a text field and change the place holder text to whatever you like
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Please enter your email ."
        })
        
        //Lets add another button and give it an action
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //Get the text from the text field
            //If you have multiple textfields added then you will change the [0]
            //adding a digit everytime you add another textfield
            let textField = alertController.textFields![0]
            
            //Print the text of the textfield to the output screen for testing purposes
            print("The email entered is:", textField.text)
            
            //Send the username to another function called sendEmail
            self .sendEmail(textField.text!)
            
        }))
        
        //Finally Present the viewcontroller when the button is clicked
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    func sendEmail(email: String) {
        //Print the username that was sent to this func for testing purposes only
        print(email);
        
        //Use the backendless service that sends the email for our user
        Types.tryblock({ () -> Void in
            
            let result = self.backendless.userService.restorePassword(email)
            print("Check your email! result = \(result)")
            
            //create the alert and set the title to Success
            //also set the message to display a custom message to inform our user
            let alertController = UIAlertController(title: "Success",
                message: "Your response has been submitted and you should recieve an email shortly",
                preferredStyle: .Alert)
            
            //Changing the style will change the the color from default blue to a red cancel button
            let defaultAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            
            //Add the button to the alertController
            alertController.addAction(defaultAction)
            
            //Finally Present the viewcontroller when the button is clicked
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
            },
            //If there is an error we would like to know about it so this next line will print this to the output console
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
                
                //create the alert and set the title to error
                //also set the message to display the error recieved from Backendless
                let alertController = UIAlertController(title: "ERROR",
                    message: exception.message,
                    preferredStyle: .Alert)
                
                //Changing the style will change the the color from default blue to a red cancel button
                let defaultAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
                
                //Add the button to the alertController
                alertController.addAction(defaultAction)
                
                //Finally Present the viewcontroller when the button is clicked
                self.presentViewController(alertController, animated: true, completion: nil)
                
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func validUserToken() {
        backendless.userService.isValidUserToken(
            { ( result : AnyObject!) -> () in
                print("isValidUserToken (ASYNC): \(result.boolValue)")
                self.backendless.userService.setStayLoggedIn( true )
                self .SegueForLoggedInUser()
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    func SegueForLoggedInUser (){
        self.performSegueWithIdentifier("Login", sender: self)
        
    }



}

