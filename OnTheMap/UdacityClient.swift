//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Molly Cox on 10/18/16.
//  Copyright © 2016 Molly Cox. All rights reserved.
//

import Foundation
// MARK: - UdacityClient: NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    var appDelegate: AppDelegate!

//
//    var udacityUserID: String = ""
//    var udacityFirstName: String = ""
//    var udacityLastName: String = ""
//    
//    // shared session
//    var session = URLSession.shared
//    
//    // authentication state
//    var sessionID : String? = ""
//    
//    // MARK: Initializers
//    
//    override init() {
//        super.init()
//    }
    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters: parametersWithApiKey, withPathExtension: method) as URL)
        
        /* 4. Make the request */
        let task = self.appDelegate.session.dataTask(with: request as URLRequest, completionHandler:  { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error: "No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data: data as NSData, completionHandlerForConvertData: completionHandlerForGET)
        })
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: udacityURLFromParameters(parameters: parametersWithApiKey, withPathExtension: method) as URL)
        let request = NSMutableURLRequest(url: NSURL(string: Constants.UdacityURL)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        
        let task = self.appDelegate.session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error: "There was an error with your request: \(String(describing: error))")
                return
            }


            /* GUARD: Was there any data returned? */
            if let data = data {
                print("The raw data is...\(data)")
                print("The response is...\(String(describing: response))")
                print("The error is...\(String(describing: error))")
                
            } else {
                sendError(error: "No data was returned by the request!")
                return
            }
            completionHandlerForPOST(data as AnyObject?, nil)
            /* 5/6. Parse the data and use the data (happens in completion handler) */
//            self.convertDataWithCompletionHandler(data: data as NSData, completionHandlerForConvertData: completionHandlerForPOST)
        })
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
//    func substituteKeyInMethod(method: String, key: String, value: String) -> String? {
//        if method.rangeOfString("{\(key)}") != nil {
//            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
//        } else {
//            return nil
//        }
//    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // create a URL from parameters
    private func udacityURLFromParameters(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = UdacityClient.Constants.ApiScheme
        components.host = UdacityClient.Constants.ApiHost
        components.path = UdacityClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]() as [URLQueryItem]?
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem as URLQueryItem)
        }
        
        return components.url! as NSURL
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}

