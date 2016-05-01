//
//  EditProfileViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/9/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class EditProfileViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var name: UITextField!
    var backendless = Backendless.sharedInstance()
    let picker = UIImagePickerController()
    var url:String?=nil
    var email:String!
    var objectId:String!
    var userObject:BackendlessUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        email = backendless.userService.currentUser.email
        fetchData()
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
        //Fetch User details
        userObject = collection.getCurrentPage().first as! BackendlessUser;
        
        //Fetch Event count
        
        let image = userObject.getProperty("image")
        
        let dq = BackendlessDataQuery();
        dq.whereClause = "UEmail = '\(email)'"
        var error: Fault?
        let bc = backendless.data.of(test.ofClass()).find(dq, fault: &error)
        if error == nil {
            userObject = collection.getCurrentPage().first as! BackendlessUser;
            let contacts = bc.getCurrentPage()
            
        }
        else {
            print("Server reported an error: \(error)")
        }
        let x = backendless.userService.currentUser.getProperty("name")
        let y = x.description
        self.name.text = y
        if backendless.userService.currentUser.getProperty("caption").description != nil {
            self.caption.text = backendless.userService.currentUser.getProperty("caption").description
        }
        
        
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

    
    @IBAction func changePassword(sender: AnyObject) {
        
        // Create the alertController
        //The alertController has two fiels that are on top of the alertController
        //The Title will be in bold and dierectly under that you will have your message.
        //You can make those say whatever you want but this is what I have chosen to go with
        let alertController = UIAlertController(title: "Change Password",
                                                message: "Enter your username below to recieve an email with the new password",
                                                preferredStyle: .Alert)
        
        //Create the button action and name it
        //Changing the style will change the the color from default blue to a red cancel button
        let defaultAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        //Add the button to the alertController
        alertController.addAction(defaultAction)
        
        //Add a text field and change the place holder text to whatever you like
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Old Password"
            textField.secureTextEntry = true
        })
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "New Password"
            textField.secureTextEntry = true
        })
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Confirm New Password"
            textField.secureTextEntry = true
        })
        
        //Lets add another button and give it an action
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            //Get the text from the text field
            //If you have multiple textfields added then you will change the [0]
            //adding a digit everytime you add another textfield
            let oldPassword = alertController.textFields![0].text
            let newPassword = alertController.textFields![1].text
            let confirmPassword = alertController.textFields![2].text
            
            self.updateUser(confirmPassword!, cP: newPassword!)
            
            
            
        }))
        
        
        
        //Finally Present the viewcontroller when the button is clicked
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func updateUser(nP:String, cP: String )  {
        
        if nP==cP {
            let currentUser = self.backendless.userService.currentUser
            currentUser.setProperty("password", object: nP)
            
            self.backendless.userService.update(currentUser)
            
            let alertController = UIAlertController(title: "Success",
                                                    message: "Your password has been changed!",
                                                    preferredStyle: .Alert)
            
            //Changing the style will change the the color from default blue to a red cancel button
            let defaultAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            
            //Add the button to the alertController
            alertController.addAction(defaultAction)
            
            //Finally Present the viewcontroller when the button is clicked
            self.presentViewController(alertController, animated: true, completion: nil)

            
            
        }
        else{
            let alertController = UIAlertController(title: "ERROR",
                                                    message: "Password do not match",
                                                    preferredStyle: .Alert)
            
            //Changing the style will change the the color from default blue to a red cancel button
            let defaultAction = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            
            //Add the button to the alertController
            alertController.addAction(defaultAction)
            
            //Finally Present the viewcontroller when the button is clicked
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        

    }
    
    
    @IBAction func deleteAccount(sender: AnyObject) {
        let alert = UIAlertController(title: "Alert", message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let logout = UIAlertAction(title: "Delte Account", style: .Default) { (action) -> Void in
            
            self.backendless.userService.logout(
                { ( user : AnyObject!) -> () in
                    print("User deleted")
                    self.performSegueWithIdentifier("logOut", sender: self)
                    
                },
                error: { ( fault : Fault!) -> () in
                    print("Server reported an error: \(fault)")
            })
            
        }
        
        
        alert.addAction(logout)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Alert", message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let logout = UIAlertAction(title: "Logout", style: .Default) { (action) -> Void in
            
            self.backendless.userService.logout(
                { ( user : AnyObject!) -> () in
                    print("User logged out.")
                    self.performSegueWithIdentifier("logOut", sender: self)
                    //self.dismissViewControllerAnimated(true, completion: {})
                    
                },
                error: { ( fault : Fault!) -> () in
                    print("Server reported an error: \(fault)")
            })
            
        }
        
        
        alert.addAction(logout)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    @IBAction func save(sender: UIButton) {
        
        if  (image.image != nil){
            //let imageData: NSData? = UIImagePNGRepresentation(image.image!)!
            
            //Compress Image
            
            let imgData:NSData? = UIImageJPEGRepresentation(image.image!, 0.1)
            
            
            let name = backendless.userService.currentUser.email
            
            //Upload Profile Picture
            
            backendless.fileService.upload("profilepic/-\(name))", content: imgData, response: {(let uploadedFile: BackendlessFile!)->() in
                
                print("File has been Uploaded -\(uploadedFile.fileURL)")
                self.url = uploadedFile.fileURL
                
                //Update user profile
                    let currentUser = self.backendless.userService.currentUser
                    
                    currentUser.setProperty("image", object: self.url)
                    currentUser.setProperty("name", object: self.name.text)
                    currentUser.setProperty("caption", object: self.caption.text)
                    currentUser.setProperty("Address", object: self.address.text)
                    self.backendless.userService.update(currentUser)
                    
                    print("User updated")
                self.navigationController?.popViewControllerAnimated(true)
                
                
                
                }, error: {(let fault: Fault!) ->() in
                    print("\(fault)")
                })
            
        }
        else
        {
            let currentUser = self.backendless.userService.currentUser
            currentUser.setProperty("name", object: self.name.text)
            currentUser.setProperty("caption", object: self.caption.text)
            currentUser.setProperty("Address", object: self.address.text)
            self.backendless.userService.update(currentUser)
            print("User updated without image")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    @IBAction func chooseImage(sender: UIButton) {
        
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        image.contentMode = .ScaleAspectFit
        image.image = chosenImage
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


