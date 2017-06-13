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

    // MARK:  Variables
    var udacityClient: UdacityClient!
    var appDelegate:  AppDelegate!

    // MARK:  Outlets
    @IBOutlet weak var findingLocation: UIActivityIndicatorView!
    
    @IBOutlet weak var studyLocation: UITextField!
    
    // MARK:  Actions
    @IBAction func cancelAddPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findStudyLocation(_ sender: Any) {

        findingLocation.isHidden = false
        findingLocation.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        findingLocation.startAnimating()
        let locationToFind =  studyLocation.text
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(locationToFind!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                performUIUpdatesOnMain {
                    self.findingLocation.isHidden = true
                }
                self.displayError(errorString: "Unable to find that location... please try again")
            }
            if let placemark = placemarks?.first {
                print("Location: \(locationToFind!)")
                print("Coordinates:  \(placemark.location!.coordinate)")
                let newLatitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
                let newLongitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
                let newLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)

                DispatchQueue.main.async {
                    self.findingLocation.isHidden = true
                    let enterLinkVC = self.storyboard!.instantiateViewController(withIdentifier: "EnterLinkViewController") as!
                        EnterLinkViewController
                    enterLinkVC.newStudentLocation = newLocation
                    enterLinkVC.mapString = self.studyLocation.text!
                    self.present(enterLinkVC, animated: true, completion: nil)
                }
                
            }
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate

        self.studyLocation.delegate = self

        self.navigationItem.title = "On The Map:  Enter Location"
        navigationController?.navigationBar.barTintColor = UIColor.white
        findingLocation.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
