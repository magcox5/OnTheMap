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
        getUdacityResult(username: userName, password: password, completionHandlerForUdacityResult: { (success, parsedResult, errorString) in
            if success {
                self.getSessionID(parsedResult: parsedResult, completionHandlerForSessionID:
                    { (success, sessionID, errorString) in
                        if success {
                        // success! we have the sessionID!
                            self.getUserID(parsedResult: parsedResult!, completionHandlerForUserID: { (success, userID, errorString) in
                                if success {
                                    self.getUserDetails(userID: userID!, completionHandlerForUserDetails: { (success, userDetails, errorString) in
                                        if success {
                                            self.getFirstName(userDetails: userDetails , completionHandlerForUdacityName: { (success, firstName, errorString) in
                                                if success {
                                                    self.getLastName(userDetails: userDetails, completionHandlerForUdacityName: { (success, lastName, errorString) in
                                                        if success {
                                                            completionHandlerForAuth(true, nil)
                                                        } else {
                                                            completionHandlerForAuth(false, "Can't get last name")
                                                        }
                                                    })
                                                } else {
                                                    completionHandlerForAuth(false, "Can't get first name")
                                                }
                                            })
                                        } else {
                                            completionHandlerForAuth(false, "Can't get user details")
                                        }
                                    })
                                }else {
                                    completionHandlerForAuth(false, "Can't get user id")
                                }
                            })
                        } else {
                            completionHandlerForAuth(false, "Can't get session ID")
                        }
                    })
                } else {
                    completionHandlerForAuth(false, "Can't parse Udacity data as JSON")
                }
        })

        }


            func getSessionID(parsedResult: AnyObject!, completionHandlerForSessionID: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) ->Void)
    {
        
            
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
            
        
            /* 6. Use the data! */
            self.appDelegate.sessionID = sessionID

            /* 7. Start the request */
            completionHandlerForSessionID(true, self.appDelegate.sessionID, nil)
    }

        func getUserID(parsedResult: AnyObject, completionHandlerForUserID: @escaping (_ success: Bool, _ userID: String?, _ errorString: String?) ->Void)
    {
        /* GUARD: Is there a userID in our result? */
        if let userData = parsedResult["account"] as? [String: AnyObject] {
            let userID = userData["key"]
            self.appDelegate.udacityUserID = userID as! String
            completionHandlerForUserID(true, userID as? String, nil)
            return
        }
        else {
            completionHandlerForUserID(false, nil, "Cannot find userID in \(parsedResult)")
            return
        }
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

    func getFirstName(userDetails: [String: AnyObject], completionHandlerForUdacityName: @escaping (_ success: Bool, _ firstName: String?, _ errorString: String?) ->Void)
    {
        
            /* GUARD: Is there a first name in our result? */
            if let firstName = userDetails["first_name"] as? String {
                self.appDelegate.udacityFirstName = firstName
                completionHandlerForUdacityName(true, firstName, nil)
                return
            }
            else {
                completionHandlerForUdacityName(false, nil, "Cannot find first name")
                return
            }
            
        
    }
    
    func getLastName(userDetails: [String: AnyObject], completionHandlerForUdacityName: @escaping (_ success: Bool,  _ lastName: String?,_ errorString: String?) ->Void)
    {
            /* GUARD: Is there a last name in our result? */
            if let lastName = userDetails["last_name"] as? String {
                self.appDelegate.udacityLastName = lastName
                completionHandlerForUdacityName(true, lastName, nil)
                return
            }
            else {
                completionHandlerForUdacityName(false, nil, "Cannot find last name")
                return
            }
            
    }
    
}

