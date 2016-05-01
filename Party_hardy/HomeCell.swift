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
    @IBOutlet weak var like: UIButton!
    
    @IBOutlet weak var disLike: UIButton!
      var imageUrl: NSURL!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData(test1: test) {
        
        self.EventName.text = test1.Name! as String
        
        self.UName.setTitle(test1.UName! as String, forState: .Normal)
        
        let address = test1.Address! + test1.City!
        
        self.EventHost.setTitle(address as String, forState: .Normal)
        
        
        
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

