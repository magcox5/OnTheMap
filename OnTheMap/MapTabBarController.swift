//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 1/29/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation
import UIKit

class MapTabBarController:  UITabBarController {
    
    @IBAction func addPin(_ sender: Any) {
        
        print("pin pressed:  add one now!")
        
        // TODO:  check if user already has a pin
        // TODO:  if a pin exists for the user, ask if the user wants to update it or cancel.
        // TODO: if user wants to update pin, show current pin info & allow editing
        // TODO:  if user  doesn't want to update it, cancel the operation
        //  TODO:  if no pin exists, get the info. to be added 
        //  TODO:  Perform necessary updates
    }
    @IBAction func exitProgram(_ sender: Any) {
        
        // TODO:  Logout of the Udacity Parse database
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
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
            // TODO:  Return to the login screen
            _ = self.navigationController?.popToRootViewController(animated: true)
            print("Am I at the login screen now?")

        }
        task.resume()
    }
    
    
}
