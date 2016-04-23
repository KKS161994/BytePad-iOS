//
//  DownloadViewController.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [String]()

    @IBOutlet weak var downloadsTable: UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("Download Cell") as UITableViewCell!
//        cell.textLabel?.text = items[indexPath.row]
//        return cell
        
        
        
        if let cell = self.downloadsTable.dequeueReusableCellWithIdentifier("Download Cell") as? DownloadsTableCell {
            
            print("HEY")
            
            cell.initCell(items[indexPath.row], detail: "", fileURL: "")
            print(cell)
            return cell
        }
        
        return DownloadsTableCell()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        items.removeAll()
        
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
//            print(directoryContents)
            
            for var file in directoryContents {
                self.items.append(file.lastPathComponent!)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        downloadsTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
