//
//  OtherProfileViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/22/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class OtherProfileViewController: UIViewController  {
    
    
    let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
    let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
    let VERSION_NUM = "v1"
    
    @IBOutlet weak var follow: UIButton!
    var backendless = Backendless.sharedInstance()
    var email:String!
    var name:String!
    var objectId:String!
    var Uemail = Emails()
    var userObject:BackendlessUser!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        self.backendless.userService.getPersistentUser()
        fetchData()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData() {
        
        print(email)
        
        let dataQuery = BackendlessDataQuery();
        // query to load user object which has objectId as the currently logged in user
        
        dataQuery.whereClause = "email = '\(email)'"
        // find operation always returns a collection
        
        let collection:BackendlessCollection = backendless.data.of(BackendlessUser.ofClass()).find(dataQuery)
        // take the first object from the collection, since there is always going to be just one
        
        userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        name = userObject.getProperty("name").string
        
        let follows = backendless.userService.currentUser.getProperty("FollowedB")
        let events  = backendless.userService.currentUser.getProperty("events")
        print(follows.count())
        if (follows.description.containsString(email) || events.description.containsString(backendless.userService.currentUser.email)){
            print("True")
            follow.hidden = true
        }
        else{
        print("False")
        }
        
        
        let coll:BackendlessCollection = backendless.data.of(Emails.ofClass()).find(dataQuery)
        
        Uemail = coll.getCurrentPage().first as! Emails;
        //print(Uemail.email)
               
    }
    

    
    @IBAction func Follow(sender: UIButton) {
        
        
        
        Types.tryblock({ () -> Void in
            
            let currentUser = self.backendless.userService.currentUser
            
            currentUser.setProperty("FollowedB", object:self.Uemail)
            
            self.backendless.userService.update(currentUser)
            
            self.follow.enabled=false
            self.follow.hidden = true
            print("User updated")
            
            },
                       
            catchblock: { (exception) -> Void in
            print("Server reported an error: \(exception)" )
        })

        
        
    }
    
}