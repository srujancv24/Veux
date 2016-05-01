//
//  HomeViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 3/5/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation
import CoreLocation


class HomeViewController: UITableViewController, ChildNameDelegate, CLLocationManagerDelegate {
    

    var ev:[test]=[]
    var email:String?
    let x: String? = nil
    var locationManager = CLLocationManager()
    var backendless = Backendless.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: 0.2, blue: 0.3, alpha: 0.5)
//        let logo = UIImage(named: "veuxlogo.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        self.fetchData()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    @IBAction func UProfile(sender: UIButton) {
        
    }
  
    func fetchData(){
        
        let dataQuery = BackendlessDataQuery()
        let whereClause = "UEmail = '\(backendless.userService.currentUser.email!)'"
        dataQuery.whereClause = whereClause
        dataQuery.queryOptions.sortBy = ["UName DESC"]
        
        var error: Fault?
        let bc = backendless.data.of(test.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            self.ev.removeAll()
            self.ev.appendContentsOf(bc.data as! [test]!)
            
        }
        else {
            print("Server reported an error: \(error)")
        }
        self.tableView.reloadData()

        
//        let dataStore = backendless.data.of(test.ofClass())
//        var error: Fault?
//        
//        let result = dataStore.findFault(&error)
//        
//        if error == nil {
//            self.ev.appendContentsOf(result.data as! [test]!)
//            
////            let contacts = result.getCurrentPage()
////            for obj in contacts as! [test]{
////                //print("\(obj.Image)")
////               
////            }
//             self.tableView.reloadData()
//        }
//            
//           
//            
//        else {
//            print("Server reported an error: \(error)")
//        }

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
        as! HomeCell
        
        cell.bindData(self.ev[indexPath.row])
        
        
        cell.like.addTarget(self, action: #selector(HomeViewController.ButtonClicked(_:)), forControlEvents: .TouchUpInside)
        
        cell.disLike.addTarget(self, action: #selector(HomeViewController.ButtonClicked(_:)), forControlEvents: .TouchUpInside)

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return ev.count
    }
    
    
    @IBAction func mapLoad(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! HomeCell
        
        let indexPath = tableView.indexPathForCell(cell)
        let address = ev[indexPath!.row].Address! + "," + ev[indexPath!.row].City! + "," + ev[indexPath!.row].State!
        
        let alert = UIAlertController(title: "Navigate Using", message:nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let googleMaps = UIAlertAction(title: "Google Maps", style: .Default) { (action) -> Void in
            
            let targetURL = NSURL(string: "comgooglemaps://?q='\(address)'")!
            
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
            let targetURL = NSURL(string: "http://maps.apple.com/?address='\(address)'")!
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
            
                let dvc = segue.destinationViewController as! DetailViewController;
            
                dvc.event = ev[indexPath.row]
            }
        }
        
        if (segue.identifier == "filter") {
            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! FilterViewController
           
            addEventViewController.delegate = self
            
        }
    }

    func dataChanged(str: String) {
        // Do whatever you need with the data
        print(str)
        
    }
    
    func ButtonClicked(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! HomeCell
        
        let indexPath = tableView.indexPathForCell(cell)

        if sender === cell.like {
            
        }
        
        if sender === cell.disLike{
            
            print("true")
        }

        else if sender === cell.disLike {
            
            print("false")
        }

    }
    
    
}
