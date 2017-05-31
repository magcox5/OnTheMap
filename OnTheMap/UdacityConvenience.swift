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
        
        // chain completion handlers for each request so that they run one after the other
        getSessionID(username: userName, password: password)
        { (success, sessionID, errorString) in
            
            if success {
                // success! we have the sessionID!
                print(sessionID as Any)
                self.sessionID = sessionID
                self.getUdacityName(userID: self.udacityUserID){ (success, errorString) in
                    if success {
                                completionHandlerForAuth(success, errorString)

                    } else {
                                completionHandlerForAuth(success, errorString)
                    }
                    
                }
            } else {
                
                        completionHandlerForAuth(success, errorString)
            }
        }
    }
    


    func getSessionID(username: String, password: String, completionHandlerForSessionID: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) ->Void)
    {
        /* 1. Set the parameters */
//        let methodParameters = [
//            UdacityClient.ParameterKeys.ApiKey: UdacityClient.Constants.ApiKey
//        ]
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        /* 4. Make the request */
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error)
                completionHandlerForSessionID(false, nil, "Login Failed (SessionID)")
            } else {
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
                    self.udacityUserID = userID as! String
                }
                else {
                    completionHandlerForSessionID(false, nil, "Cannot find userID in \(parsedResult!)")
                    return
                }
            
                /* 6. Use the data! */
                print("Session Id is: \(sessionID)")
//                self.appDelegate.sessionID = sessionID
            }
    })
        /* 7. Start the request */
        task.resume()
        
//        return
    }
    
    func getUdacityName(userID: String, completionHandlerForUdacityName: @escaping (_ success: Bool,  _ errorString: String?) ->Void)
    {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/\(userID)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForUdacityName(false, (error as! String))
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
                completionHandlerForUdacityName(false, "Could not parse udacity user data as JSON")
                return
            }
            
            /* GUARD: Is there a user in our result? */
            guard let userData = parsedResult["user"] as? [String: AnyObject]
                else {
                    completionHandlerForUdacityName(false, "Cannot find 'user' in \(parsedResult)")
                    return
            }
            print("Yes, we have a user!")
            
            /* GUARD: Is there a last name in our result? */
            if let lastName = userData["last_name"] as? String {
                print("My last name is:  \(lastName)")
                self.udacityLastName = lastName            }
            else {
                completionHandlerForUdacityName(false, "Cannot find last name")
                return
            }
            
            
            /* GUARD: Is there a first name in our result? */
            if let firstName = userData["first_name"] as? String {
                print("My first name is:  \(firstName)")
                self.udacityFirstName = firstName
            }
            else {
                completionHandlerForUdacityName(false, "Cannot find first name")
                return
            }
            
            /* 6. Use the data! */
            //            self.completeLogin()
            
        }
        /* 7. Start the request */
        task.resume()
        
//        return

    }
    
}

