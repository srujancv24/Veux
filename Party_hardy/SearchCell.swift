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
    
     var imageUrl: NSURL!
    
    func bindData(test1: test) {
        
        self.Eventtitle.text = test1.Name! as String
        
        self.UName.setTitle(test1.UName! as String, forState: .Normal)
        
        self.address.setTitle(test1.Address! as String, forState: .Normal)
        
        
        if(test1.Image != nil){
            let data = test1
            let url = NSURL(string: data.Image!)
            imageUrl = url // For recycled cells' late image loads.
            if let image = url?.cachedImage {
                // Cached: set immediately.
                EventImage.image = image
                EventImage.alpha = 1
            } else {
                // Not cached, so load then fade it in.
                EventImage.alpha = 0
                url!.fetchImage { image in
                    // Check the cell hasn't recycled while loading.
                    if self.imageUrl == url {
                        self.EventImage.image = image
                        UIView.animateWithDuration(0.3) {
                            self.EventImage.alpha = 1
                        }
                    }
                }
            }
            
        }
        else{
            let img = UIImage(named: "imageNotAvailable.jpg")
            let imgData:NSData? = UIImageJPEGRepresentation(img!, 0.0)
            self.EventImage.image = UIImage(data: imgData!)
            
        }
        
        
    }

}