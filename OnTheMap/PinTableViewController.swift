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
    
    let studentLocations = StudentArray.sharedInstance.thisStudentArray

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
    
    
}
