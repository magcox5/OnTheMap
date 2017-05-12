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

    var newStudentLocation: CLLocation?
    var firstName: String = ""
    var lastName: String = ""
    var userID: String = ""
    var mapString: String = ""

    @IBOutlet weak var studentURL: UITextField!
    
    let regionRadius: CLLocationDistance = 1000

    @IBAction func cancelAddPin(_ sender: Any) {
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})

        // self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {
        // TODO:  Post data to database
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        userID = "\"\(udacityUserID)\""
        firstName = "\"\(firstName)\""
        lastName = "\"\(lastName)\""
        mapString = "\"\(mapString)\""
        var newStudentURL = studentURL!.text!
        newStudentURL = "\"\(newStudentURL)\""
        let requestTest = "{\"uniqueKey\": \(userID),  \"firstName\": \(firstName), \"lastName\": \(lastName),\"mapString\": \(mapString), \"mediaURL\": \(newStudentURL),\"latitude\": \(newStudentLocation!.coordinate.latitude), \"longitude\": \(newStudentLocation!.coordinate.longitude)}"
        request.httpBody = "{\"uniqueKey\": \(userID),  \"firstName\": \(firstName), \"lastName\": \(lastName),\"mapString\": \(mapString), \"mediaURL\": \(newStudentURL),\"latitude\": \(newStudentLocation!.coordinate.latitude), \"longitude\": \(newStudentLocation!.coordinate.longitude)}".data(using: String.Encoding.utf8)
        print(requestTest)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()

        // TODO:  Return to Map/Table View
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        var annotation = [MKPointAnnotation].self
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
