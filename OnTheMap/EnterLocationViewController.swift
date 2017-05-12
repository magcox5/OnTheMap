//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 3/1/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import UIKit
import CoreLocation

class EnterLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:  Outlets
 
    @IBOutlet weak var studentFirstName: UITextField!
    @IBOutlet weak var studentLastName: UITextField!
    @IBOutlet weak var studyLocation: UITextField!
    
    // MARK:  Actions
    @IBAction func cancelAddPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findStudyLocation(_ sender: Any) {

        let locationToFind =  studyLocation.text
        let geoCoder = CLGeocoder()
        
        // MARK:  Error Checking
        // if an error occurs, pop up an alert view and re-enable the UI
        func displayError(_ error: String) {
            let nextController = UIAlertController()
            let okAction = UIAlertAction(title: error, style: UIAlertActionStyle.default)
            nextController.addAction(okAction)
            self.present(nextController, animated:  true, completion:nil)
        }

        // Check to make sure name field has data
        if studentLastName.text == "" {
            displayError("Please enter a last name")
        } else if studentFirstName.text == "" {
            displayError("Please enter a first name")
        } else
        {
        geoCoder.geocodeAddressString(locationToFind!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                displayError("Unable to find that location... please try again")
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                print("Location: \(locationToFind!)")
                print("Coordinates:  \(placemark.location!.coordinate)")
                let newLatitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
                let newLongitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
                let newLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)

                DispatchQueue.main.async {
                    let enterLinkVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterLinkViewController") as!
                        EnterLinkViewController
                    enterLinkVC.newStudentLocation = newLocation
                    enterLinkVC.firstName = self.studentFirstName.text!
                    enterLinkVC.lastName = self.studentLastName.text!
                    enterLinkVC.mapString = self.studyLocation.text!
                    self.present(enterLinkVC, animated: true, completion: nil)
                }
                
            }
        })
        
    }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.studentFirstName.delegate = self
        self.studentLastName.delegate = self
        self.studyLocation.delegate = self

        self.studentLastName.text = udacityLastName
        self.studentFirstName.text = udacityFirstName
        
        self.navigationItem.title = "On The Map:  Enter Location"
        navigationController?.navigationBar.barTintColor = UIColor.white
//        self.navigationItem.title.color = .White
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
