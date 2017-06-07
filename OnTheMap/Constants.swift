//
//  Constants.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // MARK: API Key
        static let AppID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK:  Content-Type
        static let ContentType: String = "application/json"
        
        // MARK: URLs
        static let ApiScheme = "https://"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let ApiSearch = "/StudentLocation?limit=100&order=-updatedAt"
        static let ApiStudent = "/StudentLocation"
        static let signupURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static let UdacityURL = "https://www.udacity.com/api/session"
        
        // MARK:  HTTP Header Fields
        static let httpHeaderApiKey = "X-Parse-REST-API-Key"
        static let httpHeaderAppID = "X-Parse-Application-Id"
        static let httpHeaderContentType = "Content-Type"
        
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "id"
    }
    
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    

    

}
