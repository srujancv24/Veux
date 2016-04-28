//
//  SearchViewController.swift
//  Party_hardy
//
//  Created by Venkata Srujan Chalasani on 4/13/16.
//  Copyright © 2016 Venkata Srujan Chalasani. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    var filteredEv:[test]=[]

    
    var searchController:UISearchController!
    
    var backendless = Backendless.sharedInstance()
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
       
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Events", "User"]
        tableView.tableHeaderView = searchController.searchBar
        
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            print(filteredEv.count)
            return filteredEv.count
        }
        else{
        return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
       let cell = tableView.dequeueReusableCellWithIdentifier("Ucell", forIndexPath: indexPath)
            as! SearchCell
        
        
        if searchController.active && searchController.searchBar.text != "" {
            cell.bindData(self.filteredEv[indexPath.row])
        } else {
            
        }
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {

        let dataQuery = BackendlessDataQuery()
        print(scope)
            //print(searchText)
        if scope=="All" {
            
            let whereClause = "UName LIKE '\(searchText)%' OR Name LIKE '\(searchText)%'"
            dataQuery.whereClause = whereClause
            
        }
        if scope=="User" {
            let whereClause = "UName LIKE '\(searchText)%'"
            dataQuery.whereClause = whereClause
        }
        
        if scope=="Events" {
            let whereClause = "Name LIKE '\(searchText)%'"
            dataQuery.whereClause = whereClause
        }
            
            
            var error: Fault?
            let bc = backendless.data.of(test.ofClass()).find(dataQuery, fault: &error)
            if error == nil {
                self.filteredEv.removeAll()
                self.filteredEv.appendContentsOf(bc.data as! [test]!)
                
            }
            else {
                print("Server reported an error: \(error)")
            }
            self.tableView.reloadData()
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

