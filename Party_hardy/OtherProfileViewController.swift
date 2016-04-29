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
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var followedBy: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var events: UILabel!
    
    var backendless = Backendless.sharedInstance()
    var email:String!
    var name:String!
    var objectId:String!
    var userObject:BackendlessUser!
    var followingCount:Int!
    
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
        //Fetch User details
        userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        
        
        //Fetch Event count
        name = userObject.getProperty("name").description
        let image = userObject.getProperty("image")
        
        let dq = BackendlessDataQuery();
        dq.whereClause = "UEmail = '\(email)'"
        var error: Fault?
        let bc = backendless.data.of(test.ofClass()).find(dq, fault: &error)
        if error == nil {
            
            let contacts = bc.getCurrentPage()
            self.events.text = contacts.count.description
            
        }
        else {
            print("Server reported an error: \(error)")
        }
        
        self.userName.text = name
    
        
        //Set Image
        let url = NSURL(string: image.description)
        if url?.description != nil {
            let dataimage = NSData(contentsOfURL: url!)
            
            self.image.image = UIImage(data: dataimage!)
        }
            
        else
        {
            let img = UIImage(named: "imageNotAvailable.jpg")
            let imgData:NSData? = UIImageJPEGRepresentation(img!, 0.0)
            self.image.image = UIImage(data: imgData!)
        }
        
    }
    
    @IBAction func Follow(sender: UIButton) {

        
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = "email = '\(backendless.userService.currentUser.email)'"
       
        
        var error: Fault?
        let bc = backendless.data.of(UserGroups.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
           
            let contacts = bc.getCurrentPage()
            
            for theGroup in contacts as! [UserGroups]{
                theGroup.users.append(userObject)
                
                var error: Fault?
                let result = backendless.data.update(theGroup, error: &error ) as? UserGroups
                followingCount = (result?.users.count)!
                
                if error == nil {
                    print("Member has been Added")
                }
                
                else{
                    print("Server reported an error: \(error)")
                }
            }
            
        }
        else {
            print("Server reported an error: \(error)")
        }

            }
}
