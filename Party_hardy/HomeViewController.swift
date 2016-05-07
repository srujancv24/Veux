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
    var rat:[Rating] = []
    var email:String?
    let x: String? = nil
    var locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    var lat:CLLocationDegrees = 0.0
    var long:CLLocationDegrees = 0.0
    var backendless = Backendless.sharedInstance()
    var like = "false"
    var dislike = "false"
    @IBOutlet weak var rating: UIProgressView!
    var curr = 0
    var max = 2
    var sort = "nil"
    var dist = 20
    var filter = "nil"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0, green: 0.2, blue: 0.3, alpha: 0.5)
//        let logo = UIImage(named: "veuxlogo.png")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
       // self.fetchData()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
        
        lat = (locationManager.location?.coordinate.latitude)!
        long = (locationManager.location?.coordinate.longitude)!
         searchingDataObjectByDistance()
        fetchRating()
        
    }

    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        
    
           }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locValue = manager.location!.coordinate
//        lat = (locationManager.location?.coordinate.latitude)!
//        long = (locationManager.location?.coordinate.longitude)!
//        print(locationManager.location?.coordinate.latitude)
//        locationManager.stopUpdatingLocation()
//        
//        searchingDataObjectByDistance()
//        
//    }
    
    
    @IBAction func UProfile(sender: UIButton) {
        
    }
  
//    func fetchData(){
//        
////        let dataQuery = BackendlessDataQuery()
////        let whereClause = "UEmail = '\(backendless.userService.currentUser.email!)'"
////        dataQuery.whereClause = whereClause
////        dataQuery.queryOptions.sortBy = ["UName DESC"]
////        
////        var error: Fault?
////        let bc = backendless.data.of(test.ofClass()).find(dataQuery, fault: &error)
////        if error == nil {
////            self.ev.removeAll()
////            self.ev.appendContentsOf(bc.data as! [test]!)
////            
////        }
////        else {
////            print("Server reported an error: \(error)")
////        }
////        self.tableView.reloadData()
//
//        
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
//
//    }
    
    func searchingDataObjectByDistance() {
        
        Types.tryblock({ () -> Void in
            let dataQuery = BackendlessDataQuery()
            
            self.ev.removeAll()
            if(self.sort == "nil" && self.dist == 20 && self.filter == "nil")
            {
                let queryOptions = QueryOptions()
                queryOptions.relationsDepth = 1;
            
                dataQuery.queryOptions = queryOptions;
                dataQuery.whereClause = "distance( \(self.lat), \(self.long), location.latitude, location.longitude ) < mi(1000)"
            }
            else{
                let queryOptions = QueryOptions()
                queryOptions.relationsDepth = 1;
                
                dataQuery.queryOptions = queryOptions;
                dataQuery.whereClause = "distance( \(self.lat), \(self.long), location.latitude, location.longitude ) < mi(\(self.dist))"
            }
           
            let events = self.backendless.persistenceService.find(test.ofClass(),
                dataQuery:dataQuery) as BackendlessCollection
            for event in events.data as! [test] {
                self.ev.appendContentsOf(events.data as! [test])
                
            }
            },
                       catchblock: { (exception) -> Void in
                        print("searchingDataObjectByDistance (FAULT): \(exception as! Fault)")
        })
    }
    
    func fetchRating(){
        
        let dataQuery = BackendlessDataQuery()
        let whereClause = "user = '\(backendless.userService.currentUser.email!)'"
        dataQuery.whereClause = whereClause
    
                var error: Fault?
                let bc = backendless.data.of(Rating.ofClass()).find(dataQuery, fault: &error)
                if error == nil {
                    self.rat.removeAll()
                    self.rat.appendContentsOf(bc.data as! [Rating]!)
                    let xc = bc.getCurrentPage()
                    for obj in xc as! [Rating]{
                        print(obj.Likes)
                    }
                    
        
                }
                else {
                    print("Server reported an error: \(error)")
                }
                self.tableView.reloadData()

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
        
//        if ev[indexPath.row].Image == nil {
//            cell.like.setImage(UIImage(named: "green.png"), forState: UIControlState.Normal)
//            like = "true"
//        }


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

   func dataChanged(str: String, str2: String, str3: Int) {
        // Do whatever you need with the data
        sort = str
        dist = str3
        filter = str2
        self.viewDidLoad()
        tableView.reloadData()
        
        }
    
    func ButtonClicked(sender: AnyObject?) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! HomeCell
        
        let indexPath = tableView.indexPathForCell(cell)
        
        let rat = Rating()
         let id = self.ev[(indexPath?.row)!].objectId
        
        let us = backendless.userService.currentUser.email
        
         let dataStore = backendless.data.of(Rating.ofClass())

        if sender === cell.like {
            if (like == "false") {
                cell.like.setImage(UIImage(named: "green.png"), forState: UIControlState.Normal)
                cell.disLike.setImage(UIImage(named: "thumbdwn.png"), forState: UIControlState.Normal)
                like = "true"
                dislike = "false"
                rat.Likes = id
                rat.user = us
                
                dataStore.save(
                    rat,
                    response: { (result: AnyObject!) -> Void in
                        let obj = result as! Rating
                        print("Like has been saved: \(obj.objectId)")
                    },
                    error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
                })
                
                if curr <= max {
                    curr = curr + 1
                    max = max + 1
                    let ratio = Float(curr) / Float(max)
                    cell.rating.progress = Float(ratio)
                    
                }
            }
            
            else {
                cell.like.setImage(UIImage(named: "thumbup.png"), forState: UIControlState.Normal)
                cell.disLike.setImage(UIImage(named: "thumbdwn.png"), forState: UIControlState.Normal)
                like = "false"
                dislike = "false"
            }

        }
        
        if sender === cell.disLike{
            if (dislike == "false") {
                cell.like.setImage(UIImage(named: "thumbup.png"), forState: UIControlState.Normal)
                cell.disLike.setImage(UIImage(named: "red.png"), forState: UIControlState.Normal)
                like = "false"
                dislike = "true"
            }
                
            
            else {
                cell.like.setImage(UIImage(named: "thumbup.png"), forState: UIControlState.Normal)
                cell.disLike.setImage(UIImage(named: "thumbdwn.png"), forState: UIControlState.Normal)
                like = "false"
                dislike = "false"
            }
           
            }
        }
    
}
