//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation
// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    var appDelegate: AppDelegate!

    // MARK: GET
    func getUdacityResult(username: String, password: String, completionHandlerForUdacityResult: @escaping (_ success: Bool, _ parsedResult: AnyObject?, _ errorString: String?) ->Void)
    {
        /* 1. Set the parameters */
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        //            let parameters = [UdacityClient.ParameterKeys.ApiKey: UdacityClient.Constants.ApiKey]
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
                print(error as Any)
                completionHandlerForUdacityResult(false, nil, "Login Failed (SessionID)")
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
    
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

