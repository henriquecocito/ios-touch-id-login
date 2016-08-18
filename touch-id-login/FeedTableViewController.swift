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
    var repositoryData : NSArray = NSArray()
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
        return self.repositoryData.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("feedTableViewCell") as! FeedTableViewCell
        cell.name.text = self.repositoryData[indexPath.row]["name"] as? String
        
        return cell
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
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        // Get http response
        if let httpResponse = response as? NSHTTPURLResponse {
            
            // Check response status code
            if httpResponse.statusCode != 200 {
                
                // Set error
                self.error = NSError(domain: httpResponse.allHeaderFields["Server"] as! String, code: httpResponse.statusCode, userInfo: nil)
                
                // Get HTTP status
                if let status = httpResponse.allHeaderFields["Status"] as? String {
                    
                    // Show error alert
                    let alert = UIAlertController(title: status, message: "An error occurred trying to access github.com\n\nTry again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &self.error) as? NSArray {
            
            if(self.error == nil) {
                self.repositoryData = jsonResult
                self.tableView.reloadData()
            }
        }
    }}
