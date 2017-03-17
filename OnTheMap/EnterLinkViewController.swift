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
    var newStudentInfo: StudentLocation?

    @IBOutlet weak var studentURL: UITextField!
    
    let regionRadius: CLLocationDistance = 1000

    @IBAction func cancelAddPin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveStudentLocation(_ sender: Any) {

        // TODO:  Post data to database
        // TODO:  Return to Map View
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.studentURL.delegate = self
        // set initial location user entered
        centerMapOnLocation(location: newStudentLocation!)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
