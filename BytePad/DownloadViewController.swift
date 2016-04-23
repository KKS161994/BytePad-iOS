//
//  DownloadViewController.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import QuickLook

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource {
    
    var items = [(name:String, url:String)]()

    @IBOutlet weak var downloadsTable: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print(items[indexPath.row].url)
        
//        performSegueWithIdentifier("DocumentViewSegue", sender: items[indexPath.row].url)
        
        let previewQL = QLPreviewController() // 4
        previewQL.dataSource = self // 5
        previewQL.currentPreviewItemIndex = indexPath.row // 6
        showViewController(previewQL, sender: nil) // 7
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = self.downloadsTable.dequeueReusableCellWithIdentifier("Download Cell") as? DownloadsTableCell {
            
            cell.initCell(items[indexPath.row].name, detail: "", fileURL: items[indexPath.row].url)

            return cell
        }
        
        return DownloadsTableCell()
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
//            let fileManager = NSFileManager.defaultManager()
//            
//            // Delete 'hello.swift' file
//            
//            do {
//                try fileManager.removeItemAtPath(String(items[indexPath.row].url))
//            }
//            catch let error as NSError {
//                print("Ooops! Something went wrong: \(error)")
//            }
            
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
                print(file.lastPathComponent)
                print(file.absoluteURL)
                
                // Save the data in the list as a tuple
                self.items.append((file.lastPathComponent!, file.absoluteString))
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        downloadsTable.reloadData()
    }
    
    // MARK: Preview
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        return NSURL(string: items[index].url)!
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
