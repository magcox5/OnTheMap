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
    let latitude: Float
    let longitude: Float
    let createdAt: Date
    let updatedAt: Date
    
    init(dictionary: [String:AnyObject]) {
        objectID = dictionary["objectID"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        latitude = dictionary["latitude"] as! Float
        longitude = dictionary["longitude"] as! Float
        createdAt = dictionary["createdAt"] as! Date
        updatedAt = dictionary["updatedAt"] as! Date
        
    }
    
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocation = [StudentLocation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            studentLocation.append(StudentLocation(dictionary: result))
        }
        
        return studentLocation
    }
    
}




