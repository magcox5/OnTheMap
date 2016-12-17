//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/27/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit

struct StudentLocation {
    
    // MARK: Properties
    // First initialize values in the struct
    
    var objectID: String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init(value:[String:AnyObject]) {
        // Check each variable for nil value, then update if there is a value
        if let objectID = value["objectID"] as? String {
            self.objectID = objectID
        }
        if let uniqueKey = value["uniqueKey"] as? String {
            self.uniqueKey = uniqueKey
        }
        if let firstName = value["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = value["lastName"] as? String {
            self.lastName = lastName
        }
        if let mapString = value["mapString"] as? String {
            self.mapString = mapString
        }
        if let mediaURL = value["mediaURL"] as? String {
            self.mediaURL = mediaURL
        }
        if let latitude = value["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = value["longitude"] as? Double {
            self.longitude = longitude
        }
        if let createdAt = value["createdAt"] as? Date {
            self.createdAt = createdAt
        }
        if let updatedAt = value["updatedAt"] as? Date {
            self.updatedAt = updatedAt
        }
    }
    
    static func studentLocationsFromResults(results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(value:result))
        }
        
        return studentLocations
    }
    
}




