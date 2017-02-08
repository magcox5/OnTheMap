//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Molly Cox on 11/20/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate  {
    
    // MARK:  Variables

    let studentLocations = StudentArray.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
 
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.navigationController?.title = "On The Map"
        
        // Get the student locations for display
        // getStudentLocations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Get the student locations to populate the map
        getStudentLocations()
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
                self.displayStudentLocations()
            }
        }
        task.resume()

    }
    
    
    private func displayStudentLocations() {
//            print("Made it to displayStudentLocations!")
        var annotations = [MKPointAnnotation]()
        let locations = self.studentLocations.thisStudentArray
            for student in locations {
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(student.latitude) 
            let long = CLLocationDegrees(student.longitude)

                // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        

   
}
}
