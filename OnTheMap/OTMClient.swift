//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Molly Cox on 3/28/17.
//  Copyright © 2017 Molly Cox. All rights reserved.
//

import Foundation

// MARK: - TMDBClient: NSObject

class OTMClient : NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    // authentication state
    var requestToken: String? = nil
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
}
    
    
}
