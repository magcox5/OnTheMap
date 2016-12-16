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
    
    let objectID: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
    let updatedAt: Date
    
    init(value:[String:AnyObject]) {
        objectID = (value["objectID"] as? String)!
        uniqueKey = (value["uniqueKey"] as? String)!
        firstName = (value["firstName"] as? String)!
        lastName = (value["lastName"] as? String)!
        mapString = (value["mapString"] as? String)!
        mediaURL = (value["mediaURL"] as? String)!
        latitude = (value["latitude"] as? Double)!
        longitude = (value["longitude"] as? Double)!
        createdAt = (value["createdAt"] as? Date)!
        updatedAt = (value["updatedAt"] as? Date)!
        
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




