//
//  FilterViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 5/1/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class FilterViewController: UIViewController {
    
    var delegate: ChildNameDelegate?
    let x = "srujan"
    
    func whereTheChangesAreMade(data: String) {
        if let del = delegate {
            del.dataChanged(data)
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        
        //mDelegate?.sendArrayToPreviousVC(sd)
        whereTheChangesAreMade(x)
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

protocol ChildNameDelegate {
    func dataChanged(str: String)
}
