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
        return pinCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let currentPin = StudentArray.sharedInstance.thisStudentArray[indexPath.row]

        UIApplication.shared.open(NSURL(string: currentPin.mediaURL)! as URL, options: [:], completionHandler: nil)
}
    
    private func getStudentLocations() {
        //        let test = UdacityClient.Constants.ApiScheme
        let request = NSMutableURLRequest(url: NSURL(string: "\(UdacityClient.Constants.ApiScheme)\(UdacityClient.Constants.ApiHost)\(UdacityClient.Constants.ApiPath)\(UdacityClient.Constants.ApiSearch)")! as URL)
        
        request.addValue(UdacityClient.Constants.AppID, forHTTPHeaderField: UdacityClient.Constants.httpHeaderAppID)
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: UdacityClient.Constants.httpHeaderApiKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                self.displayError(errorString: "There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                self.displayError(errorString: "No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                self.displayError(errorString: "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* 6. Parse the data for Result */
            if let pinResults = parsedResult["results"] {
                print(pinResults!)
                // Store student locations in data structure
                self.studentLocations.thisStudentArray = StudentArray.arrayFromResults(results: pinResults as! [[String : AnyObject]])
            }
            // Switch to Main Queue to display pins on map
//            DispatchQueue.main.async {
//                self.displayStudentLocations()
//            }
        }
        task.resume()
        
    }
    
    func refreshTable() {
        getStudentLocations()
    }
    
    private func displayError(errorString: String) {
        let nextController = UIAlertController()
        let okAction = UIAlertAction(title: "Error: \(String(describing: errorString))", style: UIAlertActionStyle.default)
        nextController.addAction(okAction)
        self.present(nextController, animated:  true, completion:nil)
    }
    

    
}
