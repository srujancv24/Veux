//
//  DetailViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/28/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation


class DetailViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var address: UIButton!
    @IBOutlet weak var UEmail: UIButton!
    

    var event=test()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.address.setTitle(event.Address, forState: .Normal)
        self.comments.text = event.Comments
        self.UEmail.setTitle(event.UEmail, forState: .Normal)
       
         if event.Image != nil {
        let url = NSURL(string: event.Image!)
        
       
            let dataimage = NSData(contentsOfURL: url!)
            
            self.ImageView.image = UIImage(data: dataimage!)
        }
            
        else
        {
            let img = UIImage(named: "imageNotAvailable.jpg")
            let imgData:NSData? = UIImageJPEGRepresentation(img!, 0.0)
            self.ImageView.image = UIImage(data: imgData!)
        }
   
    }
    
    @IBAction func sendEmail(sender: AnyObject) {
        
        let em = event.UEmail!
        let x = "mailto:"
        let y = x.stringByAppendingString(em)
        print(y)
        UIApplication.sharedApplication().openURL(NSURL(string: y)!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
