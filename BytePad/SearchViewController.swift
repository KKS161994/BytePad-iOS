//
//  ViewController.swift
//  Bytepad-test
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    
    var papers = [Paper]()
    var filteredPapers = [Paper]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPapers.count
        }
        return papers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        
        let paper: Paper
        
        if searchController.active && searchController.searchBar.text != "" {
            paper = filteredPapers[indexPath.row]
        } else {
            paper = papers[indexPath.row]
        }
        
        cell.textLabel?.text = paper.name
        //                cell.textLabel?.text = String(indexPath.row)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPapers = papers.filter { paper in
            let categoryMatch = (scope == "All") || (paper.exam == scope)
            return  categoryMatch && paper.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        table.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //        filterContentForSearchText(searchController.searchBar.text!)
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
    }
    
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://silive.in/bytepad/rest/api/paper/getallpapers?query=")
            .responseJSON { response in   // server data
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                self.table.hidden = false
                                print(response.result)   // result of response serialization
                
                let json = JSON(response.result.value!)
                
                for item in json{
                    //                    print(item)
                    let title = item.1["Title"].string!.characters.split(".").map(String.init)[0]
                    let category = item.1["ExamCategory"].string
                    let url = item.1["URL"].string
                    
                    let paper = Paper(name: title, exam: category!, url: url!)
                    self.papers.append(paper)
                }
                self.table.reloadData()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "ST1", "ST2", "PUT", "UT"]
        searchController.searchBar.delegate = self
        activityIndicator.startAnimating()
        
//        searchController.searchBar.barTintColor = UIColor.redColor()
//        searchController.searchBar.tintColor = UIColor.whiteColor()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

