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
        UdacityClient.logoutOfDatabase()

        // MARK:  Return to the login screen
        self.dismiss(animated: true, completion: nil)
    }
}
