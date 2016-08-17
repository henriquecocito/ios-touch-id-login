//
//  FeedTableViewController.swift
//  
//
//  Created by Henrique Cocito on 8/13/16.
//
//

import UIKit

class FeedTableViewController: UITableViewController, NSURLConnectionDataDelegate {

    var data : NSDictionary!
    var error : NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRepositories()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedHeaderTableViewCell") as! FeedHeaderTableViewCell
        cell.name.text = (self.data["name"] as! NSString).description
        cell.bio.text = (self.data["bio"] as! NSString).description
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
    
    
    func getRepositories() {
        
        // Clear previous errors
        self.error = nil
        
        // Create NSURL Object
        let apiUrl = NSURL(string: NSString(format: "%@/users/%@/repos", Configurations.apiHost, "henriquecocito") as String)
        
        // Create URL Request
        let request = NSMutableURLRequest(URL: apiUrl!)
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"

        // Perform the request
        let urlConnection = NSURLConnection(request: request, delegate: self)

    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {

    }}
