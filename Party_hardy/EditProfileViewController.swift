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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
