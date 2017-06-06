//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Molly Cox on 3/28/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import UIKit
import Foundation

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, userName: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // chain completion handlers for each request so that they run one after the other
        getSessionID(username: userName, password: password, completionHandlerForSessionID:
        { (success, sessionID, errorString) in
            
            if success {
                // success! we have the sessionID!
                print(sessionID as Any)
                self.appDelegate.sessionID = sessionID
                        self.getFirstName(userID: self.appDelegate.udacityUserID, completionHandlerForUdacityName: { (success, firstName, errorString) in
                            if success {
                                print(firstName as String!)
                                self.appDelegate.udacityFirstName = firstName!
                                self.getLastName(userID: self.appDelegate.udacityUserID, completionHandlerForUdacityName: { (success, lastName, errorString) in
                                    if success {
                                        print(lastName as Any)
                                        self.appDelegate.udacityLastName = lastName!
                                        completionHandlerForAuth(true, nil)
                                    } else {
                                        completionHandlerForAuth(false, "Can't get last name")
                                    }
                                    
                                })
                                
                    } else {
                        completionHandlerForAuth(false, "Unable to complete login...")
                    }
                })
            }
            
        })

    }
    

    func getSessionID(username: String, password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) ->Void)
    {
        /* 1. Set the parameters */
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let parameters =
        [UdacityClient.ParameterKeys.ApiKey: UdacityClient.Constants.ApiKey]
        print(parameters)
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: NSURL(string: UdacityClient.Constants.UdacityURL)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = self.appDelegate.session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print(error as Any)
                completionHandlerForSessionID(false, nil, "Login Failed (SessionID)")
                return
            }
            
            // Strip off 1st 5 characters in data
            let newData = (data! as NSData).subdata(with: NSMakeRange(5, (data?.count)! - 5))
            print(newData)
            
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject!
            } catch {
                completionHandlerForSessionID(false, nil, "Could not parse the data as JSON: '\(newData)'")
                return
            }
            
            
            /* GUARD: First, is there a session in our result? */
            guard let sessionData = parsedResult["session"] as? NSDictionary
                else {
                    completionHandlerForSessionID(false, nil, "Login Failed:  invalid username/password")
                    return
            }
            
            /* GUARD: Is there a session_id in our result? */
            guard let sessionID = sessionData[UdacityClient.ParameterKeys.SessionID] as? String
                else {
                    completionHandlerForSessionID(false, nil, "Cannot find key '\(UdacityClient.ParameterKeys.SessionID)'in \(parsedResult!)")
                    return
            }
            
            /* GUARD: Is there a userID in our result? */
            if let userData = parsedResult["account"] as? [String: AnyObject] {
                print(userData)
                let userID = userData["key"]
                print("My user id is:  \(userID!)")
                self.appDelegate.udacityUserID = userID as! String
            }
            else {
                completionHandlerForSessionID(false, nil, "Cannot find userID in \(parsedResult!)")
                return
            }
            
            /* 6. Use the data! */
            print("Session Id is: \(sessionID)")
            self.appDelegate.sessionID = sessionID

            /* 7. Start the request */
            completionHandlerForSessionID(true, self.appDelegate.sessionID, nil)

        })
        task.resume()
        
    }

    func getUserID(sessionID: String, completionHandlerForUserID: @escaping (_ success: Bool, _ userID: String?, _ errorString: String?) ->Void)
    {
        
    }
    
    func getFirstName(userID: String, completionHandlerForUdacityName: @escaping (_ success: Bool, _ firstName: String?, _ errorString: String?) ->Void)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
//        let session = URLSession.shared
        let task = self.appDelegate.session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForUdacityName(false, nil, (error as! String))
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5. Parse the data */
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                completionHandlerForUdacityName(false, nil, "Could not parse udacity user data as JSON")
                return
            }
            
            /* GUARD: Is there a user in our result? */
            guard let userData = parsedResult["user"] as? [String: AnyObject]
                else {
                    completionHandlerForUdacityName(false, nil, "Cannot find 'user' in \(parsedResult)")
                    return
            }
            print("Yes, we have a user!")
            
            
            /* GUARD: Is there a first name in our result? */
            if let firstName = userData["first_name"] as? String {
                print("My first name is:  \(firstName)")
                self.appDelegate.udacityFirstName = firstName
                completionHandlerForUdacityName(true, firstName, "Found First Name")
                return
            }
            else {
                completionHandlerForUdacityName(false, nil, "Cannot find first name")
                return
            }
            
        }
        /* 7. Start the request */
        task.resume()
        
    }
    
    func getLastName(userID: String, completionHandlerForUdacityName: @escaping (_ success: Bool,  _ lastName: String?,_ errorString: String?) ->Void)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
//        let session = URLSession.shared
        let task = self.appDelegate.session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForUdacityName(false, nil, (error as! String))
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            /* 5. Parse the data */
            let parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String: AnyObject]
            } catch {
                completionHandlerForUdacityName(false, nil, "Could not parse udacity user data as JSON")
                return
            }
            
            /* GUARD: Is there a user in our result? */
            guard let userData = parsedResult["user"] as? [String: AnyObject]
                else {
                    completionHandlerForUdacityName(false, nil, "Cannot find 'user' in \(parsedResult)")
                    return
            }
            print("Yes, we have a user!")
            
            
            /* GUARD: Is there a first name in our result? */
            if let lastName = userData["last_name"] as? String {
                print("My last name is:  \(lastName)")
                self.appDelegate.udacityLastName = lastName
                completionHandlerForUdacityName(true, lastName, "Found Last Name")
                return
            }
            else {
                completionHandlerForUdacityName(false, nil, "Cannot find last name")
                return
            }
            
        }
        /* 7. Start the request */
        task.resume()
        

    }
    
}

