//
//  HomeCell.swift
//  Party_hardy
//
//  Created by Megi Shehi on 3/11/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class HomeCell : UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventHost: UIButton!
    @IBOutlet weak var UName: UIButton!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(test1: test) {
        
        self.EventName.text = test1.Name! as String
        
        self.UName.setTitle(test1.UName! as String, forState: .Normal)
        
        self.EventHost.setTitle(test1.Address! as String, forState: .Normal)
        
        let email = test1.UEmail
        
        if(test1.Image != nil){
            
            let url = NSURL(string: test1.Image!)
            
            let dataimage = NSData(contentsOfURL: url!)
            
            self.EventImage.image = UIImage(data: dataimage!)
            
        }
        
        else
        {
        self.EventImage.image = UIImage(named: "imageNotAvailable.jpg")
        }
        
       
        
        
    }
    
    
}
