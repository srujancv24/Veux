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
    var email:String!
    var name:String!
    var objectId:String!
    var userObject:BackendlessUser!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        self.backendless.userService.getPersistentUser()
        fetchData()
        userGroup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchData() {
        
        let dataQuery = BackendlessDataQuery();
        // query to load user object which has objectId as the currently logged in user
        
        dataQuery.whereClause = "email = '\(email)'"
        // find operation always returns a collection
        
        let collection:BackendlessCollection = backendless.data.of(BackendlessUser.ofClass()).find(dataQuery)
        // take the first object from the collection, since there is always going to be just one
        
        userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        name = userObject.getProperty("name").string
       
    }
    
    func userGroup(){
        
        //let User = userResults[indexPath.row]
        
        
        
        let group = self.backendless.persistenceService.of(UserGroup().ofClass())
        
        //let member1 = backendless.userService.findById(objectId)
        var user = UserGroup()
        user.GroupName = backendless.userService.currentUser.name
        user.Email = backendless.userService.currentUser.email
        user.Following.append(userObject)
        
        user = group.save(user) as! UserGroup
        
        
        let currentUser = backendless.userService.currentUser
        userObject.setProperty("FollowedBy", object: currentUser)
        backendless.userService.update(userObject)
        
        
        }
    
    @IBAction func Follow(sender: UIButton) {
        
        let member1 = backendless.userService.findById(objectId)
        
        let query = BackendlessDataQuery()
        
        let group = backendless.persistenceService.of(UserGroup.ofClass()).find(query)
        
        let currentPage = group.getCurrentPage()
        
        for theGroup in currentPage as! [UserGroup] {
            
            
            if theGroup.ownerId != userObject.objectId {
                
                theGroup.Following.append(userObject)
                
                var error: Fault?
                
                let result = backendless.data.update(theGroup, error: &error) as? UserGroup
                
                if error == nil {
                    
                    print("Member havs been added: \(result)")
                    
                } else {
                    
                    print("Server reported an error: \(error)")
                    
                }
                
            } else {
                
                print("You are the owner of this group !")
                
            }
            
        }
    }
    
}