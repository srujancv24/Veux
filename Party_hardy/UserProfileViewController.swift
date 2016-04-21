//
//  UserProfileViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/9/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class UserProfileViewController: UIViewController {
    
    
    let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
    let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    var error: Fault?
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Name: UILabel!
    
    var user:String?
    
    override func viewDidLoad() {
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        self.backendless.userService.getPersistentUser()
       
        
        super.viewDidLoad()
        
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    
    func fetchData() {
        
        let dataQuery = BackendlessDataQuery();
        // query to load user object which has objectId as the currently logged in user
        
        dataQuery.whereClause = "objectId = '\(backendless.userService.currentUser.objectId)'"
        // find operation always returns a collection
        
        let collection:BackendlessCollection = backendless.data.of(BackendlessUser.ofClass()).find(dataQuery)
        // take the first object from the collection, since there is always going to be just one
        
        let userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        print(userObject.getProperty("name"))
       
        
    }
    
   
    
    

}
