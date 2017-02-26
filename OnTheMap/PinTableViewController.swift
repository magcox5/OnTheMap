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

    // Reload table view when view appears/loads
    override func viewDidLoad() {
        super.viewDidLoad()
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentLocations()
        tableView.reloadData()
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
        print(pinCell.textLabel?.text as Any)
        print(pinCell.detailTextLabel?.text as Any)
        
        return pinCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentPin = StudentArray.sharedInstance.thisStudentArray[indexPath.row]

        let pinDetailName =         currentPin.firstName.trimmingCharacters(in: .whitespaces) + " " + currentPin.lastName.trimmingCharacters(in: .whitespaces)

        let okController = UIAlertController(title: pinDetailName, message: currentPin.mediaURL, preferredStyle: .alert)

        okController.addAction(UIAlertAction(title: "OK", style: .default))

        present(okController, animated: true)

}
    
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
                self.studentLocations.thisStudentArray = StudentArray.arrayFromResults(results: pinResults as! [[String : AnyObject]])
            }
            // Switch to Main Queue to display pins on map
            DispatchQueue.main.async {
 //               self.displayStudentLocations()
            }
        }
        task.resume()
        
    }
    
}
