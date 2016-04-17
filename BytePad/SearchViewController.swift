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
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    @IBAction func retryButton(sender: UIButton) {
        self.loadingMessageLabel.hidden = false
        self.loadingMessageLabel.text = "While the satellite moves into position..."
        self.activityIndicator.hidden = false
        self.activityIndicator.startAnimating()
        self.retryButton.hidden = true
        self.getPapersData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPapers.count
        }
        return papers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let paper: Paper
        
        if searchController.active && searchController.searchBar.text != "" {
            paper = filteredPapers[indexPath.row]
        } else {
            paper = papers[indexPath.row]
        }
        
        if let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as? PapersTableCell {
            
            cell.initCell(paper.name, detail: paper.detail)
            print(cell)
            return cell
        }
        
        return PapersTableCell()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let downloadMenu = UIAlertController(title: nil, message: "Confirm Download", preferredStyle: .ActionSheet)
        
        
        let saveAction = UIAlertAction(title: "Download", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        downloadMenu.addAction(saveAction)
        downloadMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(downloadMenu, animated: true, completion: nil)
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
        
        self.getPapersData()
        
        // Do any additional setup after loading the view, typically from a nib.
//        self.table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
    
    func getPapersData(){
        Alamofire.request(.GET, "http://silive.in/bytepad/rest/api/paper/getallpapers?query=")
            .responseJSON { response in   // server data
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidden = true
                
                // If the network works fine
                if response.result.isFailure != true {
                    
                    
                    print("network okay")
                    
                    
                    self.loadingMessageLabel.hidden = true
                    self.table.hidden = false
                    //print(response.result)   // result of response serialization
                    
                    let json = JSON(response.result.value!)
                    
                    for item in json{
                        //                    print(item)
                        let title = item.1["Title"].string!.characters.split(".").map(String.init)[0]
                        let category = item.1["ExamCategory"].string
                        let url = item.1["URL"].string
                        let detail = item.1["PaperCategory"].string
                        
                        let paper = Paper(name: title, exam: category!, url: url!, detail: detail!)
                        self.papers.append(paper)
                        
                    }
                    self.table.reloadData()
                    
                }
                    // If the network fails
                else {
                    self.retryButton.hidden = false
                    
                    print("network fucked up")
                    self.loadingMessageLabel.text = "Check your internet connectivity"
                }
                
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

