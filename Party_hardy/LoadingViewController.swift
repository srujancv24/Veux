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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
        let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
        let VERSION_NUM = "v1"
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func login(sender: AnyObject) {
        validUserToken()
        
    }
    
    func validUserToken() {
        backendless.userService.isValidUserToken(
            { ( result : AnyObject!) -> () in
                
                if(result.boolValue == true){
                print("isValidUserToken (ASYNC): \(result.boolValue)")
                
                self.backendless.userService.setStayLoggedIn( true )
                self .SegueForLoggedInUser()
                }
                else{
                    self.performSegueWithIdentifier("LoginScreen", sender: self)
                }
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error (ASYNC): \(fault)")
            }
        )
    }
    func SegueForLoggedInUser (){
        self.performSegueWithIdentifier("LoginSuccess", sender: self)
        
    }

}
