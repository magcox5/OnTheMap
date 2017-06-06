//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var udacityUserID: String = ""
    var udacityFirstName: String = ""
    var udacityLastName: String = ""
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var sessionID : String? = ""
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }

    
    var window: UIWindow?

    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

//    var sharedSession = URLSession.shared
//    var sessionID: String = ""

}

//// MARK: Create URL from Parameters
//
//extension AppDelegate {
//    
//    func udacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
//        
//        var components = URLComponents()
//        components.scheme = UdacityClient.Constants.ApiScheme
//        components.host = UdacityClient.Constants.ApiHost
//        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
//        components.queryItems = [URLQueryItem]()
//        
//        for (key, value) in parameters {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems!.append(queryItem)
//        }
//        
//        return components.url!
//    }
//}
