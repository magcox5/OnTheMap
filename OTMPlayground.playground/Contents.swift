//: Playground - noun: a place where people can play

import UIKit
import CoreLocation

let locationToFind = "Palos Verdes, California"
let geoCoder = CLGeocoder()

geoCoder.geocodeAddressString(locationToFind, completionHandler: {(placemarks, error) -> Void in
    if((error) != nil){
        print("Unable to find that location... please try again")
        print("Error", error as Any)
    }
    if let placemark = placemarks?.first {
        print("Location: \(locationToFind)")
        print("Coordinates:  \(placemark.location!.coordinate)")
        let newLatitude: CLLocationDegrees = (placemark.location?.coordinate.latitude)!
        let newLongitude: CLLocationDegrees = (placemark.location?.coordinate.longitude)!
        let newLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)
        
        print("Latitude:  \(newLatitude)")
        print("Longitude:  \(newLongitude)")
        print("Location:  \(newLocation)")

        
    }
})

