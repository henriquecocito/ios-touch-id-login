//
//  LoginViewController.swift
//  touch-id-login
//
//  Created by Henrique Cocito on 8/1/16.
//  Copyright (c) 2016 Henrique Cocito. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NSURLConnectionDataDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var error : NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: UIButton) {

        // Clear previous errors
        self.error = nil
        
        // Create NSURL Object
        let apiUrl = NSURL(string: NSString(format: "%@/users/%@", Configurations.apiHost, "henriquecocito") as String)
        
        // Create URL Request
        let request = NSMutableURLRequest(URL: apiUrl!)
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        // Get credentials
        let loginString = NSString(format: "%@:%@", username.text, password.text)
        let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64LoginString = loginData.base64EncodedStringWithOptions(nil)
        
        // Set authentication header
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
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
        
        if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {

            if(self.error == nil) {
                performSegueWithIdentifier("showFeed", sender: jsonResult)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showFeed") {
            var destinationController = segue.destinationViewController as! FeedTableViewController
            destinationController.data = sender as! NSDictionary
        }
    }
}

