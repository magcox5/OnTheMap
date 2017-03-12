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
    
    @IBOutlet weak var studyLocation: UITextField!
    
    
    
    @IBAction func findStudyLocation(_ sender: Any) {

        let locationToFind =  studyLocation.text
        let geoCoder = CLGeocoder()
        
        // MARK:  Error Checking
        // if an error occurs, pop up an alert view and re-enable the UI
        func displayError(_ error: String) {
            let nextController = UIAlertController()
            let okAction = UIAlertAction(title: error, style: UIAlertActionStyle.default){ action in self.dismiss(animated: true, completion: nil)}
            nextController.addAction(okAction)
            self.present(nextController, animated:  true, completion:nil)
        }

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

                DispatchQueue.main.async {
                    let enterLinkVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterLinkViewController") as!
                        EnterLinkViewController
                    enterLinkVC.newStudentLocation = newLocation
                    self.present(enterLinkVC, animated: true, completion: nil)
                }
                
            }
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
