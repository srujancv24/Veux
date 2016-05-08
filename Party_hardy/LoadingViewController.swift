//
//  LoadingViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 5/3/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class LoadingViewController: UIViewController {
    
    var backendless = Backendless.sharedInstance()
    var res:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
        let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
        let VERSION_NUM = "v1"
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        validUserToken()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func login(sender: AnyObject) {
        if res == true {
            self.SegueForLoggedInUser()
        }
        else{
        self.performSegueWithIdentifier("LoginScreen", sender: self)
        }
        
    }
    
    func validUserToken() {
        backendless.userService.isValidUserToken(
            { ( result : AnyObject!) -> () in
                
                
                print("isValidUserToken (ASYNC): \(result.boolValue)")
                
                self.backendless.userService.setStayLoggedIn( true )
                //self .SegueForLoggedInUser()
                self.res = result.boolValue
                
//                else{
//                    self.performSegueWithIdentifier("LoginScreen", sender: self)
//                }
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    func SegueForLoggedInUser (){
        self.performSegueWithIdentifier("LoginSuccess", sender: self)
        
    }
    
    func retrieveDeviceRegistrationAsync(deviceId: String) {
        backendless.messaging.getRegistrationAsync(deviceId,response: {(result:DeviceRegistration!)->() in
            print("Device\(result)")
            },
            error:{(fault:Fault!)-> () in
                print("error")}
            )
        
    }

}
