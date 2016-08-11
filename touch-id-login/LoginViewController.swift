//
//  LoginViewController.swift
//  touch-id-login
//
//  Created by Henrique Cocito on 8/1/16.
//  Copyright (c) 2016 Henrique Cocito. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, NSURLConnectionDataDelegate, NSURLConnectionDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: UIButton) {
        
        // Create NSURL Object
        let apiUrl = NSURL(string: NSString(format: "%@/%@/%@", Configurations.apiHost, "users", "henriquecocito") as String)
        
        // Create URL Request
        let request = NSMutableURLRequest(URL: apiUrl!)
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        // Get credentials
        let loginString = NSString(format: "%@:%@", "username", "password")
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

            let name = jsonResult["name"] as? NSString
            let bio = jsonResult["bio"] as? NSString
        }
    }
}

