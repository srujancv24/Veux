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
    var email:String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
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
                
                
                }, error: {(let fault: Fault!) ->() in
                    print("\(fault)")
                }
            )
        }
        else
        {
            self.addNewEvent(self.eventName.text!, comments: self.Comments.text!, address: self.address.text!, city: self.city.text!, state: self.state.text!, zipcode: self.zipcode.text!, date: self.date.date, image:"",UName: backendless.userService.currentUser.name, UEmail: backendless.userService.currentUser.email)
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
        
        
        let address = address + "," + city + "," + state + "," + zipcode
        print(address)
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                 self.longitude = placemark.location!.coordinate.longitude
                 self.latitude = placemark.location!.coordinate.latitude
                print(self.latitude)
                print(self.longitude)
                
                
                event.location = GeoPoint.geoPoint(GEO_POINT(latitude: self.latitude!, longitude: self.longitude!), categories: ["events"], metadata: ["city": city]) as? GeoPoint
                
                Types.tryblock({ () -> Void in
                    let currentUser = self.backendless.userService.currentUser
                    
                    currentUser.setProperty("events", object: event)
                    
                    self.backendless.userService.update(currentUser)
                    
                    print("User updated")
                    
                    
                    //Create Success Alert
                    let alertView = UIAlertController(title: "Success", message: "Event has been Created", preferredStyle: .Alert)
                    
                    let Ok = UIAlertAction (title: "Ok", style: .Destructive ) { alertAction in
                        
                        // self.performSegueWithIdentifier("eventCreated", sender: self)
                        self.navigationController?.popViewControllerAnimated(true)
                        //self.dismissViewControllerAnimated(true, completion: {})
                    }
                    alertView.addAction(Ok)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                    },
                    
                    catchblock: { (exception) -> Void in
                        print("Server reported an error: \(exception)" )
                })
                
            }
        })
        
        
    }
    
   
    @IBAction func selectImage(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Select Using", message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .Default) { (action) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)
        
        }
    
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
    
        let camera = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
        
        self.picker.allowsEditing = false
        self.picker.sourceType = .Camera
        self.presentViewController(self.picker, animated: true, completion: nil)
            }
            alert.addAction(camera)
    
        }
        else{
            print("Camera Not Available")
            }
        alert.addAction(photoLibrary)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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

