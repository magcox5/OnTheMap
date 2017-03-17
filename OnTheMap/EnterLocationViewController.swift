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
    
    // MARK:  Variables
    var newStudentInfo: StudentLocation?

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
                print("Location: \(locationToFind)")
                print("Coordinates:  \(placemark.location!.coordinate)")
                let newLatitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
                let newLongitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
                let newLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)

                // Store data to newStudentInfo struct
                self.newStudentInfo?.objectID = studentUserID
                self.newStudentInfo?.firstName = self.studentFirstName.text!
                self.newStudentInfo?.lastName = self.studentLastName.text!
                self.newStudentInfo?.latitude = newLatitude
                self.newStudentInfo?.longitude = newLongitude
                self.newStudentInfo?.mapString = locationToFind!
                
                
                DispatchQueue.main.async {
                    let enterLinkVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterLinkViewController") as!
                        EnterLinkViewController
                    enterLinkVC.newStudentLocation = newLocation
                    enterLinkVC.newStudentInfo = self.newStudentInfo
                    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
