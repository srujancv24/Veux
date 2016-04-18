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
    
    func fetchData(){
        
        
        user = self.backendless.userService.currentUser.name
        print(user)

            
            let whereClause = "name='\(user)'"
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = whereClause
            
            var error: Fault?
            let bc = Backendless.sharedInstance().data.of(Users.ofClass()).find(dataQuery, fault: &error)
            if error == nil {
                for user in bc.data as! [Users] {

                     print(user.name)

                    self.Name.text = user.name
                    
                    //Retrieving Image
                 //   let url = NSURL(string: user.Image!)
                    
                   // let dataimage = NSData(contentsOfURL: url!)
                    
                   // self.Image.image = UIImage(data: dataimage!)
        
            }
            }
            else {
                print("Server reported an error: \(error)")
            }
        
    }
    
    

}
