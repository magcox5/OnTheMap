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

    // MARK: Variables
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

}
