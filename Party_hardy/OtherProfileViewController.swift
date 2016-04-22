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
    
    var backendless = Backendless.sharedInstance()
    
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
        
        let dataQuery = BackendlessDataQuery();
        // query to load user object which has objectId as the currently logged in user
        
        dataQuery.whereClause = "email = 'srujancv24@gmail.com'"
        // find operation always returns a collection
        
        let collection:BackendlessCollection = backendless.data.of(BackendlessUser.ofClass()).find(dataQuery)
        // take the first object from the collection, since there is always going to be just one
        
        let userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        print(userObject.getProperty("name"))
       
        
        
    }
    
}