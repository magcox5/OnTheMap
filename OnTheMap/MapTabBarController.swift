//
//  MapTabBarController.swift
//  OnTheMap
//
//  Created by Molly Cox on 1/29/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation
import UIKit

class MapTabBarController:  UITabBarController {
    
    var studentUserID: String?
    
    @IBAction func addPin(_ sender: Any) {
    }
    @IBAction func refreshPins(_ sender: Any) {
        print("Loading 100 latest pins...")
        if self.selectedViewController! is MapViewController {
            let controller = self.selectedViewController as! MapViewController
            controller.refreshMap()
        } else if self.selectedViewController! is PinTableViewController {
            let controller = self.selectedViewController as! PinTableViewController
            controller.refreshTable()
        } else {
            let nextController = UIAlertController()
            let okAction = UIAlertAction(title: "Error: \(String(describing: self.selectedViewController))", style: UIAlertActionStyle.default)
            nextController.addAction(okAction)
            self.present(nextController, animated:  true, completion:nil)
            
        }
    }
    @IBAction func exitProgram(_ sender: Any) {
        
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

        // MARK:  Return to the login screen
        self.dismiss(animated: true, completion: nil)
    }
}
