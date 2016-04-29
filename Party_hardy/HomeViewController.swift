//
//  HomeViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 3/5/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation


class HomeViewController: UITableViewController {
    

    var ev:[test]=[]
    var email:String?
    
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.cyanColor()
//        let logo = UIImage(named: "veuxlogo.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        self.fetchData()
       
    }
    @IBAction func UProfile(sender: UIButton) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
       // viewDidLoad()
    
    
    func fetchData(){

        
        let dataStore = backendless.data.of(test.ofClass())
        var error: Fault?
        
        let result = dataStore.findFault(&error)
        
        if error == nil {
            self.ev.appendContentsOf(result.data as! [test]!)
            
//            let contacts = result.getCurrentPage()
//            for obj in contacts as! [test]{
//                //print("\(obj.Image)")
//               
//            }
             self.tableView.reloadData()
        }
            
           
            
        else {
            print("Server reported an error: \(error)")
        }

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
        as! HomeCell
        
        cell.bindData(self.ev[indexPath.row])
        print(ev[indexPath.row].UEmail)

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
       
        
        return ev.count
    }
    
    
    @IBAction func mapLoad(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Navigate Using", message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: .Default) { (action) -> Void in
            
            let targetURL = NSURL(string: "comgooglemaps://?q=cupertino")!
            
            let isAvailable = UIApplication.sharedApplication().canOpenURL(targetURL)
            if(isAvailable){
                UIApplication.sharedApplication().openURL(targetURL)
            }
            else{
                let url = NSURL(string: "comgooglemaps://")
                UIApplication.sharedApplication().openURL(url!)
            }
            
            
        }
        
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .Default) { (action) -> Void in
            let targetURL = NSURL(string: "http://maps.apple.com/?q=cupertino")!
            let isAvailable = UIApplication.sharedApplication().canOpenURL(targetURL)
            if(isAvailable){
                UIApplication.sharedApplication().openURL(targetURL)
            }
            else{
                let url = NSURL(string: "http://maps.apple.com/")!
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
        
        alert.addAction(googleMaps)
        alert.addAction(appleMaps)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Uprofile") {
            
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! HomeCell
            
            let indexPath = tableView.indexPathForCell(cell)
            email = ev[indexPath!.row].UEmail
            
            let svc = segue.destinationViewController as! OtherProfileViewController;
            
            svc.email = email
            
        }
        
        if (segue.identifier == "Detail") {
            
            if let indexPath = tableView.indexPathForSelectedRow {
            
            email = ev[indexPath.row].UEmail

            
            let dvc = segue.destinationViewController as! DetailViewController;
            
                dvc.event = ev[indexPath.row]
            }
        }
    }
 
}



