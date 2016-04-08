//
//  ViewController.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 07/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

import Alamofire
import SwiftSpinner
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var papers = [Paper]()
    var filteredPapers = [Paper]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var papersTable: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
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
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        Alamofire.request(.GET, "http://silive.in/bytepad/rest/api/paper/getallpapers?query=")
            .responseJSON { response in   // server data
                self.activityIndicator.stopAnimating()
                self.papersTable.hidden = false
//                print(response.result)   // result of response serialization
                
                let json = JSON(response.result.value!)
                
                for item in json{
//                    print(item)
                    let title = item.1["Title"].string!.characters.split(".").map(String.init)[0]
                    let category = item.1["ExamCategory"].string
                    let url = item.1["URL"].string
                    
                    let paper = Paper(name: title, exam: category!, url: url!)
                    self.papers.append(paper)
                }
                self.papersTable.reloadData()
        }
        
        self.papersTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        papersTable.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = ["All", "ST1", "ST2", "PUT", "UT"]
        searchController.searchBar.delegate = self
        
        
        // Activity Indicator
        
        activityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

