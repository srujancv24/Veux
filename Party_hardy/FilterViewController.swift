//
//  FilterViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 5/1/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmented: UISegmentedControl!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var delegate: ChildNameDelegate?
    let x = "srujan"
    var date:String?
    var rating: String?
    var filteredEv  = ["Bar","Club","Organization","Individual"]
    
    func whereTheChangesAreMade(data: String, date:String, rating: String) {
        if let del = delegate {
            del.dataChanged(data)
            del.dataChanged(date)
            del.dataChanged(rating)
        }
    }
    @IBAction func sliderChanged(sender: UISlider) {
        
        let currentValue = Int(sender.value)
        
        value.text = "\(currentValue)"
    }
    
    @IBAction func save(sender: AnyObject) {
        
        //mDelegate?.sendArrayToPreviousVC(sd)
       whereTheChangesAreMade(x, date: date!, rating: rating!)
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        if filteredEv.count == 0 {
            return 0
        }
        else{
            return filteredEv.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("filterCell", forIndexPath: indexPath)
            as UITableViewCell!
        
        // cell.textLabel.text = self.groupList[indexPath.row]
       cell.textLabel?.text = filteredEv[indexPath.row]
        
        return cell
    }

    @IBAction func sortChanged(sender: AnyObject) {
        
        switch segmented.selectedSegmentIndex {
        case 0:
            rating = "rating"
        case 1:
            date = "date"
        default:
            break
        }
    }
}

protocol ChildNameDelegate {
    func dataChanged(str: String)
}
