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
    
    var sort = "nil"
    var filter = "nil"
    var dist = 20
    
    var filteredEv  = ["Bar","Club","Organization","Individual"]
    
    func whereTheChangesAreMade(data: String, data1: String, data2:Int) {
        if let del = delegate {
            del.dataChanged(data, str2: data1, str3: data2)
            
        }
    }
    @IBAction func sliderChanged(sender: UISlider) {
        
        let currentValue = Int(sender.value)
        dist = currentValue
        
        value.text = "\(currentValue) Miles"
    }
    
    @IBAction func save(sender: AnyObject) {
        
        //mDelegate?.sendArrayToPreviousVC(sd)
       whereTheChangesAreMade(sort, data1: filter, data2: dist)
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        print(filteredEv[indexPath.row])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }

    @IBAction func sortChanged(sender: AnyObject) {
        
        switch segmented.selectedSegmentIndex {
        case 0:
            sort = "nil"
        case 1:
            sort = "nil"
        default:
            break
        }
    }
}

protocol ChildNameDelegate {
    func dataChanged(str: String, str2: String, str3: Int)
    
}
