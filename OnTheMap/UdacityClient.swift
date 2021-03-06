//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation
// MARK: - UdacityClient: NSObject

class UdacityClient {
    
    // MARK: Properties
    var appDelegate: AppDelegate!

    // MARK: GET
    func getUdacityResult(username: String, password: String, completionHandlerForUdacityResult: @escaping (_ success: Bool, _ parsedResult: AnyObject?, _ errorString: String?) ->Void)
    {
        /* 1. Set the parameters */
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: NSURL(string: UdacityClient.Constants.UdacityURL)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = self.appDelegate.session.dataTask(with: request, completionHandler: { (data, response,error) in
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandlerForUdacityResult(false, nil, error?.localizedDescription)
                return
            }
            
            // Strip off 1st 5 characters in data
            let newData = (data! as NSData).subdata(with: NSMakeRange(5, (data?.count)! - 5))
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject!
            } catch {
                completionHandlerForUdacityResult(false, nil, "Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            /* 6. Use the data! */
            
            /* 7. Start the request */
            completionHandlerForUdacityResult(true, parsedResult, nil)
            
        })
        task.resume()
        
    }
    
    func getUserDetails(userID: String, completionHandlerForUserDetails: @escaping (_ success: Bool, _ userDetails: [String: AnyObject], _ errorString: String?) -> Void)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        
        let task = self.appDelegate.session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForUserDetails(false, ["":"" as AnyObject], (error as! String))
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            /* 5. Parse the data */
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                completionHandlerForUserDetails(false, ["":"" as AnyObject], "Could not parse udacity user data as JSON")
                return
            }
            
            /* GUARD: Is there a user in our result? */
            guard let userData = parsedResult["user"] as? [String: AnyObject]
                else {
                    completionHandlerForUserDetails(false, ["":"" as AnyObject], "Cannot find 'user' in \(parsedResult)")
                    return
            }
            completionHandlerForUserDetails(true, userData, nil)
            return
            
        }
        /* 7. Start the request */
        task.resume()
        
        
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    class func logoutOfDatabase() -> Void {
        // MARK:  Logout of the Udacity Parse database
        let request = NSMutableURLRequest(url: URL(string: UdacityClient.Constants.UdacityURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(uncheckedBounds: (5, data!.count - 5))
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
}

