//
//  PinTableViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 2/2/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation

import UIKit

class PinTableViewController: UITableViewController {

    // MARK:  Variables
    
    var studentLocations = StudentArray.sharedInstance.thisStudentArray

    @IBOutlet var pinTableView: UITableView!
    
    
    // Reload table view when view appears/loads
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        pinTableView.reloadData()
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
        // return 100
    }
    
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let pinCell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        
        let currentPin = studentLocations[indexPath.row]
        
        // Set the labels
        pinCell.textLabel?.text = currentPin.firstName.trimmingCharacters(in: .whitespaces) + " " + currentPin.lastName.trimmingCharacters(in: .whitespaces)
        pinCell.detailTextLabel?.text = currentPin.mapString
        print(pinCell.textLabel?.text as Any)
        print(pinCell.detailTextLabel?.text as Any)
        
        return pinCell
    }
    
//    override 
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("pinDetailViewController") as! pinDetailViewController
//        detailController.detailPin = pinsList.pins[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
//        
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            pinsList.pins.removeAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
//        }
//    }
    
    private func getStudentLocations() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")! as URL)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* 6. Parse the data for Result */
            if let pinResults = parsedResult["results"] {
                print(pinResults!)
                // Store student locations in data structure
                self.studentLocations = StudentArray.arrayFromResults(results: pinResults as! [[String : AnyObject]])
            }
            // Switch to Main Queue to display pins on map
            DispatchQueue.main.async {
 //               self.displayStudentLocations()
            }
        }
        task.resume()
        
    }
    
}
