//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Molly Cox on 6/7/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class OnTheMapClient : NSObject {
    
    // MARK: Properties
    var appDelegate: AppDelegate!
    

    func getStudentLocations(studentLocations: StudentArray!, completionHandlerForStudentLocations: @escaping (_ success: Bool, _ studentLocations: StudentArray?, _ errorString: String?) -> Void) {
        let studentLocations = StudentArray.sharedInstance
        let request = NSMutableURLRequest(url: NSURL(string: "\(UdacityClient.Constants.ApiScheme)\(UdacityClient.Constants.ApiHost)\(UdacityClient.Constants.ApiPath)\(UdacityClient.Constants.ApiSearch)")! as URL)
    
        request.addValue(UdacityClient.Constants.AppID, forHTTPHeaderField: UdacityClient.Constants.httpHeaderAppID)
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: UdacityClient.Constants.httpHeaderApiKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            /* GUARD: Was there an error? */
 
            guard (error == nil) else {
                print("There was an error with your request: \(String(describing: error))")
                completionHandlerForStudentLocations(false, nil, "There was an error with your request: \(String(describing: error))")
                return
            }
        
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForStudentLocations(false, nil, "No data was returned by the request!")
                return
            }
        
            /* 5. Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandlerForStudentLocations(false, nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
        
            /* 6. Parse the data for Result */
            if let pinResults = parsedResult["results"] {
                print(pinResults!)
                // Store student locations in data structure
                studentLocations.thisStudentArray = StudentArray.arrayFromResults(results: pinResults as! [[String : AnyObject]])
            }
            completionHandlerForStudentLocations(true, studentLocations, nil)
        
        }
        task.resume()
    
        return
    }

    class func useableURL(thisURL: String) -> Bool {
        if let url = URL(string: thisURL) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    class func postToDatabase(mapString: String, studentURL: String, studentLocation: CLLocation, completionHandlerForPostToDatabase: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        // MARK:  Post data to database
        var appDelegate:  AppDelegate!
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        let request = NSMutableURLRequest(url: NSURL(string: "\(UdacityClient.Constants.ApiScheme)\(UdacityClient.Constants.ApiHost)\(UdacityClient.Constants.ApiPath)\(UdacityClient.Constants.ApiStudent)")! as URL)
        request.httpMethod = "POST"
        request.addValue(UdacityClient.Constants.AppID, forHTTPHeaderField: UdacityClient.Constants.httpHeaderAppID)
        request.addValue(UdacityClient.Constants.ApiKey, forHTTPHeaderField: UdacityClient.Constants.httpHeaderApiKey)
        
        request.addValue(UdacityClient.Constants.ContentType, forHTTPHeaderField: UdacityClient.Constants.httpHeaderContentType)
        
        let userID = "\"\(appDelegate.udacityUserID)\""
        let firstName = "\"\(appDelegate.udacityFirstName)\""
        let lastName = "\"\(appDelegate.udacityLastName)\""
        let mapString = "\"\(mapString)\""
        var newStudentURL = studentURL
        newStudentURL = "\"\(newStudentURL)\""
        request.httpBody = "{\"uniqueKey\": \(userID),  \"firstName\": \(firstName), \"lastName\": \(lastName),\"mapString\": \(mapString), \"mediaURL\": \(newStudentURL),\"latitude\": \(studentLocation.coordinate.latitude), \"longitude\": \(studentLocation.coordinate.longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                // Handle error…
                completionHandlerForPostToDatabase(false, "There was an error with your request: \(String(describing: error))")
                return
            }
        }
        
        completionHandlerForPostToDatabase(true, nil)
        task.resume()
    }

    // MARK: Shared Instance
    
    class func sharedInstance() -> OnTheMapClient {
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        return Singleton.sharedInstance
    }
    

}
