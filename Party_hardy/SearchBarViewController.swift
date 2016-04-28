//
//  SearchBarViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/28/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import Foundation

class SearchBarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var backendless = Backendless.sharedInstance()
    var searchActive : Bool = false
    var ev:[test]=[]
    var filteredEv:[test]=[]
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        fetchData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func search(searchText: String? = nil){
        
        
        if(searchText != nil){
            print(searchText)
            let x = searchText
            let whereClause = "UName = '\(x)'"
            let dataQuery = BackendlessDataQuery()
            dataQuery.whereClause = whereClause
            
        
        var error: Fault?
        let bc = backendless.data.of(test.ofClass()).find(dataQuery, fault: &error)
        if error == nil {
            self.ev.appendContentsOf(bc.data as! [test]!)
            
            let contacts = bc.getCurrentPage()
                        for obj in contacts as! [test]{
                            print("\(obj.UEmail)")
            
                        }
        }
        else {
            print("Server reported an error: \(error)")
        }
            self.tableView.reloadData()
        }
        
    }

//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        filteredEv = ev.filter({ (text) -> Bool in
//            let tmp: test = text
//            let range = tmp.UEmail!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
//    }
    
    
    
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
        }
            
        else {
            print("Server reported an error: \(error)")
        }
        
    }

    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell")! as UITableViewCell;
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath)
            as! SearchBarCell
        if(searchActive){
            //cell.textLabel?.text = filtered[indexPath.row]
            cell.Eventtitle.text = filtered[indexPath.row]
        } else {
            //cell.textLabel?.text = data[indexPath.row];
            cell.Eventtitle.text = data[indexPath.row]
        }
        
        return cell;
    }

}
