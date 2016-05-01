//
//  UserProfileViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/9/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class UserProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    let APP_ID = "B0AF361C-8AA4-CD18-FF63-677A5ACB5200"
    let SECRET_KEY = "C5DB14C3-420E-500E-FFB2-0AABE09E8F00"
    let VERSION_NUM = "v1"
    
  
    var error: Fault?
    
    
    var email:String!
    var name:String!
    var objectId:String!
    var userObject:BackendlessUser!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var events: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var followedBy: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var UName: UILabel!

    @IBOutlet weak var address: UILabel!
    
    var backendless = Backendless.sharedInstance()
    var user:String?
    
    

    var filteredEv:[test]=[]
    
    override func viewDidLoad() {
        
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        self.backendless.userService.getPersistentUser()
        
        email = backendless.userService.currentUser.email
       
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        super.viewDidLoad()
        
        fetchData()
        followers()
        Following()
        fetchTableData()
        
        
    }
    
    func fetchTableData(){
        let dataQuery = BackendlessDataQuery()
        
        let whereClause = "UEmail = '\(email)'"
        dataQuery.whereClause = whereClause
        
        
        var error: Fault?
        let bc = backendless.data.of(test.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            self.filteredEv.removeAll()
            self.filteredEv.appendContentsOf(bc.data as! [test]!)
            
        }
        else {
            print("Server reported an error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if filteredEv.count == 0 {
            return 0
        }
        else{
            return filteredEv.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pCell", forIndexPath: indexPath)
            as! profileCell
        
        // cell.textLabel.text = self.groupList[indexPath.row]
        cell.bindData(self.filteredEv[indexPath.row])
        
        return cell
    }
    
 
    
    func fetchData() {
        
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
        let caption = userObject.getProperty("caption").description
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
        
        self.UName.text = name
        self.caption.text = caption
        
        //Set Image
        let url = NSURL(string: image.description)
        if url?.description != nil {
            let dataimage = NSData(contentsOfURL: url!)
            
            self.Image.image = UIImage(data: dataimage!)
        }
            
        else
        {
            let img = UIImage(named: "imageNotAvailable.jpg")
            let imgData:NSData? = UIImageJPEGRepresentation(img!, 0.0)
            self.Image.image = UIImage(data: imgData!)
        }
    }
    
    func Following(){
        
        let dataQuery = BackendlessDataQuery()
        
        dataQuery.whereClause = "email = '\(email)'"
        
        // dataQuery.whereClause = "users.email = \'\(email)\'"
        
        var error: Fault?
        let bc = backendless.data.of(UserGroups.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            
            let result = bc.getCurrentPage()
            if result.count == 0 {
                following.text = "0"
            }
            else{
                for theGroup in result as! [UserGroups]{
                    let followin = theGroup.users.count
                    following.text = followin.description
                }
                
            }
            
        }
        else {
            print("Server reported an error: \(error)")
        }
    }
    
    func followers(){
        let dataQuery = BackendlessDataQuery()
        
        //dataQuery.whereClause = "email = '\(backendless.userService.currentUser.email)'"
        
        dataQuery.whereClause = "users.email = \'\(email)\'"
        
        
        var error: Fault?
        let bc = backendless.data.of(UserGroups.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            
            let result = bc.getCurrentPage()
            if result.count == 0 {
                following.text = "0"
            }
            else{
                
                followedBy.text = result.count.description
                
                
            }
            
        }
        else {
            print("Server reported an error: \(error)")
        }
    }
    
    

}
