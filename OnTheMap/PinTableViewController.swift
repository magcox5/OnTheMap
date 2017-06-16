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
    let studentLocations = StudentArray.sharedInstance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get the student locations to populate the map
        OnTheMap.getStudentLocations(studentLocations: studentLocations, completionHandlerForStudentLocations:
            { (success, studentLocations, errorString) in
                if success {
                    // Switch to Main Queue to show table
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else {
                    self.displayError(errorString: errorString!)
                }
        })
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let studentLoc = studentLocations.thisStudentArray
        return studentLoc.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pinCell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        
        let currentPin = StudentArray.sharedInstance.thisStudentArray[indexPath.row]
        
        // Set the labels
        pinCell.textLabel?.text = currentPin.firstName.trimmingCharacters(in: .whitespaces) + " " + currentPin.lastName.trimmingCharacters(in: .whitespaces)
        pinCell.detailTextLabel?.text = currentPin.mapString
        return pinCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentPin = StudentArray.sharedInstance.thisStudentArray[indexPath.row]

        if useableURL(thisURL: currentPin.mediaURL) {
            UIApplication.shared.open(NSURL(string: currentPin.mediaURL)! as URL, options: [:], completionHandler: nil)
        } else {
            displayError(errorString: "Looks like this isn't a valid URL...")
        }
}
    
    func refreshTable() {
        // Get the student locations to show table
        OnTheMap.getStudentLocations(studentLocations: studentLocations, completionHandlerForStudentLocations:
            { (success, studentLocations, errorString) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else {
                    self.displayError(errorString: errorString!)
                }
        })
    }
}
