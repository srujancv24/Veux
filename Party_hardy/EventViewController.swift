//
//  EventViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 3/5/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation


class EventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var backendless = Backendless.sharedInstance()
    let picker = UIImagePickerController()
    var strDate:String? = nil
    var url:String?=nil
    
    @IBOutlet weak var imageName: UITextField!
    
    @IBOutlet weak var eventName: UITextField!
    
    @IBOutlet weak var Comments: UITextField!
    
    @IBOutlet weak var image: UIImageView!
  
    @IBAction func datePicket(sender: AnyObject) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            }
    
    
    
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    
    
    override func viewDidLoad() {
                
      
        //updateCurrentUserPropsSync()
        super.viewDidLoad()
        
        picker.delegate = self
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createEvent(sender: UIButton) {
      
        if  (image.image != nil){
             //let imageData: NSData? = UIImagePNGRepresentation(image.image!)!
            
            //Compress Image
            
            let imgData:NSData? = UIImageJPEGRepresentation(image.image!, 0.1)
            
            
        let name = backendless.userService.currentUser.email
            let imgName = self.imageName.text!
        
        
            backendless.fileService.upload("-\(name)/-\(imgName))", content: imgData, response: {(let uploadedFile: BackendlessFile!)->() in
                
                print("File has been Uploaded -\(uploadedFile.fileURL)")
                self.url = uploadedFile.fileURL
                
                
                self.addNewEvent(self.eventName.text!, comments: self.Comments.text!, address: self.address.text!, city: self.city.text!, state: self.state.text!, zipcode: self.zipcode.text!, date: self.date.date, image: self.url!,UName: self.backendless.userService.currentUser.name, UEmail: self.backendless.userService.currentUser.email)
                
                
                
                self.tabBarController?.selectedIndex=0
                
                }, error: {(let fault: Fault!) ->() in
                    print("\(fault)")
                }
            )
        }
        else
        {
            self.addNewEvent(self.eventName.text!, comments: self.Comments.text!, address: self.address.text!, city: self.city.text!, state: self.state.text!, zipcode: self.zipcode.text!, date: self.date.date, image: self.url!,UName: backendless.userService.currentUser.name, UEmail: backendless.userService.currentUser.email)
        }
    }
    
    func addNewEvent(name: String, comments: String, address: String, city: String, state: String, zipcode: String, date:NSDate, image:String, UName:String, UEmail:String){
    let event = test()
        event.Name = name
        event.Comments=comments
        event.Address=address
        event.City=city
        event.State=state
        event.Zipcode=zipcode
        event.EventDate=date
        event.Image=url
        event.UName = UName
        event.UEmail = UEmail
        
        
//        let dataQuery = BackendlessDataQuery();
//        // query to load user object which has objectId as the currently logged in user
//        
//        dataQuery.whereClause = "objectId = '\(backendless.userService.currentUser.objectId)'"
//        // find operation always returns a collection
//        
//        let collection:BackendlessCollection = backendless.data.of(BackendlessUser.ofClass()).find(dataQuery)
//        // take the first object from the collection, since there is always going to be just one
//        
//        let userObject = collection.getCurrentPage().first as! BackendlessUser;
//        
//        print(userObject)
//        
//        let  properties = [
//            "name" : "Me",
//            "events" : event
//        ]
//        backendless.userService.currentUser.updateProperties(properties)
        
//       
        
        //Update User
        let currentUser = backendless.userService.currentUser
        currentUser.setProperty("name", object: "Srujan Chalasani" )
        currentUser.setProperty("events", object: event)
        backendless.userService.update(currentUser)
        
    
        
        
        
//        let updatedName = updatedUser.getProperty("name")
//        print( "user has been updated. Name \(updatedName)" )
        
        
        
        
        
        
        
//        let dataStore = backendless.data.of(event.ofClass())
//        
//        // save object synchronously
//        var error: Fault?
//        let result = dataStore.save(event, fault: &error) as? test
//        if error == nil {
//            print("Event has been created \(result!.Name)")
//        }
//        else {
//            print("Server reported an error: \(error)")
//        }
        
        
        
        
//        let storeData = backendless.data.of(event.ofClass())
//        storeData.save(event,
//            response: {(result : AnyObject!) -> Void in
//               let obj = result as! Events
//                print ("Event has been created \(obj.Name)")
//        },
//            error: {(fault : Fault!) -> Void in
//                print ("Server reported an Error: \(fault)")
//        })
        
    }
    
    
//    func updateCurrentUserPropsSync() {
//        Types.tryblock({ () -> Void in
//            let currentUser = self.backendless.userService.currentUser
//            print("User has been logged in (SYNC): \(currentUser)")
//            let properties = [
//                "name" : "Agent 007"
//            ]
//            currentUser.updateProperties( properties )
//            let updatedUser = self.backendless.userService.update(currentUser)
//            print("User updated (SYNC): \(updatedUser)")
//            },
//                       catchblock: { (exception) -> Void in
//                        print("Server reported an error: \(exception)" )
//        })
//    }
    
   
    @IBAction func selectImage(sender: AnyObject) {
        
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

