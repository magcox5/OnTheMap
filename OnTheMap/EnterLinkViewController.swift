//
//  EnterLinkViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 3/6/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class EnterLinkViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate   {

    // MARK:  Variables

    var udacityClient: UdacityClient!
    var newStudentLocation: CLLocation?
    var firstName: String = ""
    var lastName: String = ""
    var userID: String = ""
    var mapString: String = ""
    var appDelegate:  AppDelegate!
    
    @IBOutlet weak var studentURL: UITextField!
    
    let regionRadius: CLLocationDistance = 1000

    @IBAction func cancelAddPin(_ sender: Any) {
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        OnTheMapClient.postToDatabase(mapString: mapString, studentURL: studentURL.text!, studentLocation: newStudentLocation!) { (success, errorString) in
            if success == false {
                    self.displayError(errorString: errorString!)
            }
        }
        // MARK:  Return to Map/Table View
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Do any additional setup after loading the view.
        self.studentURL.delegate = self
        // set initial location user entered
        centerMapOnLocation(location: newStudentLocation!)
        displayStudentLocations()
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func displayStudentLocations() {
        let location = self.newStudentLocation
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
        let coordinate = location?.coordinate
        let first = firstName
        let last = lastName
        let mediaURL = studentURL.text
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations([annotation])
        print("Annotation Added")
    }

}
