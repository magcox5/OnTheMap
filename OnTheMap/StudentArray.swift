//
//  StudentArray.swift
//  OnTheMap
//
//  Created by Molly Cox on 12/15/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation

// This is the Array that will hold the student locations
// It is a singleton

class StudentArray {
    class var sharedInstance: StudentArray {
        struct Static {
            static var instance: StudentArray = StudentArray()
        }
        return Static.instance
    }
    var thisStudentArray: [StudentLocation] = [StudentLocation]()
    
    var studentLocation: StudentLocation!
    
    static func arrayFromResults(results: [[String: AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()
        for result in results {
            studentLocations.append(StudentLocation(value: result))
        }
        return studentLocations
    }
}
