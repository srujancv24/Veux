//
//  SearchViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/13/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    
    var ev:[test]=[]
    var candies = [Candy]()
    var filteredCandies = [Candy]()
    
    var searchController:UISearchController!
    
    var backendless = Backendless.sharedInstance()
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        searchController = UISearchController(searchResultsController: nil)
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
       
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        tableView.tableHeaderView = searchController.searchBar
        
        candies = [
            Candy(category:"Chocolate", name:"Chocolate Bar"),
            Candy(category:"Chocolate", name:"Chocolate Chip"),
            Candy(category:"Chocolate", name:"Dark Chocolate"),
            Candy(category:"Hard", name:"Lollipop"),
            Candy(category:"Hard", name:"Candy Cane"),
            Candy(category:"Hard", name:"Jaw Breaker"),
            Candy(category:"Other", name:"Caramel"),
            Candy(category:"Other", name:"Sour Chew"),
            Candy(category:"Other", name:"Gummi Bear")]
        
        }
    
    
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
    
//    override func viewWillAppear(animated: Bool) {
//        //clearsSelectionOnViewWillAppear = splitViewController!.collapsed
//        super.viewWillAppear(animated)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCandies.count
        }
        return ev.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Ucell", forIndexPath: indexPath)
 
        let cell = tableView.dequeueReusableCellWithIdentifier("Ucell", forIndexPath: indexPath)
            as! SearchCell
        
        cell.bindData(self.ev[indexPath.row])
        let candy: Candy
        if searchController.active && searchController.searchBar.text != "" {
            candy = filteredCandies[indexPath.row]
        } else {
           // candy = candies[indexPath.row]
            
        }
//        cell.textLabel!.text = ev[indexPath.row].UEmail
        
       // cell.detailTextLabel!.text = candy.category
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCandies = candies.filter({( candy : Candy) -> Bool in
            let categoryMatch = (scope == "All") || (candy.category == scope)
            return categoryMatch && candy.name.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
    // MARK: - Segues
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let candy: Candy
//                if searchController.active && searchController.searchBar.text != "" {
//                    candy = filteredCandies[indexPath.row]
//                } else {
//                    candy = candies[indexPath.row]
//                }
//                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
//                controller.detailCandy = candy
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
//        }
//    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
    }
}
    


extension SearchViewController: UISearchResultsUpdating {
   
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

