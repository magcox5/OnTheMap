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
    
    var window: UIWindow?
    
    var sharedSession = URLSession.shared
    var sessionID: String = ""

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
