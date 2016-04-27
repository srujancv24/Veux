//
//  SearchCell.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/26/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation



class SearchCell: UITableViewCell {

    
   
    @IBOutlet weak var EventImage: UIImageView!
    @IBOutlet weak var Eventtitle: UILabel!
    @IBOutlet weak var UName: UIButton!
    @IBOutlet weak var address: UIButton!
    
    
    func bindData(test1: test) {
        
        self.Eventtitle.text = test1.Name! as String
        
        self.UName.setTitle(test1.UName! as String, forState: .Normal)
        
        self.UName.setTitle(test1.Address! as String, forState: .Normal)
        
        
        if(test1.Image != nil){
            
            let url = NSURL(string: test1.Image!)
            
            let dataimage = NSData(contentsOfURL: url!)
            
            self.EventImage.image = UIImage(data: dataimage!)
            
        }
            
        else
        {
            let img = UIImage(named: "imageNotAvailable.jpg")
            let imgData:NSData? = UIImageJPEGRepresentation(img!, 0.0)
            self.EventImage.image = UIImage(data: imgData!)
        }
        
        
        
        
    }

}