//
//  ViewController.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 07/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var papers = [Paper]()
    var filteredPapers = [Paper]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var papersTable: UITableView!
    
    //MARK: Search
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPapers = papers.filter { paper in
            let categoryMatch = (scope == "All") || (paper.exam == scope)
            return  categoryMatch && paper.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        papersTable.reloadData()
    }
    
    //MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPapers.count
        }
        return papers.count

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.papersTable.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let paper: Paper
        
        if searchController.active && searchController.searchBar.text != "" {
            paper = filteredPapers[indexPath.row]
        } else {
            paper = papers[indexPath.row]
        }
        
        cell.textLabel?.text = paper.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: Search Bar
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        papersTable.reloadData()
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        papers = [
            Paper(exam: "PUT", name: "ncs 601"),
            Paper(exam: "PUT", name: "ncs 602"),
            Paper(exam: "PUT", name: "ncs 603"),
            Paper(exam: "ST1", name: "ncs 604"),
            Paper(exam: "ST2", name: "ncs 605"),
            Paper(exam: "ST1", name: "ncs 601"),
            Paper(exam: "ST2", name: "ncs 602"),
            Paper(exam: "ST1", name: "ncs 603"),
            Paper(exam: "ST2", name: "ncs 604")
        ]
        
        self.papersTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        papersTable.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "ST1", "ST2", "PUT"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

