//
//  HttpServiceHelper.swift
//  Nanodegree_OnTheMap
//
//  Created by Xuan Yuan (Frank) on 7/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation

protocol APIConfig {
    var ApiScheme: String { get }
    var ApiHost: String { get }
    var ApiPath: String { get }
}

struct HttpServiceHelper {
    
    static func buildURL(config:APIConfig,  withPathExtension: String, queryItems:[String:AnyObject]?) -> NSURL? {
        
        let components = NSURLComponents()
        // Setup by config
        components.scheme = config.ApiScheme
        components.host = config.ApiHost
        components.path = config.ApiPath + withPathExtension
        
        // Ensure the path start with "/"
        if components.path?.characters.first != "/"{
            components.path?.insert("/", atIndex: (components.path?.startIndex)!)
        }
        
        // Adding query items
        if let queryItems = queryItems where queryItems.count > 0 {
            components.queryItems = [NSURLQueryItem]()
            
            for (key, value) in queryItems {
                let queryItem = NSURLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.URL
    }
    
    static func parseJSONResponse(data:NSData?, error:NetworkError, completeHandler:(AnyObject?, NetworkError) -> Void) -> Void {
        
        if (error == NetworkError.Succeed && data != nil) {
            /* Parse the data */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                
                completeHandler(nil, NetworkError.ParseJSONError)
                return
            }
            
            completeHandler(parsedResult, error)
            
        } else {
            completeHandler(data, error)
        }
    }
    
    static func showErrorAlert(error: NetworkError, forViewController viewController:UIViewController) {
        var errorText = ""
        switch error {
        case .Succeed:
            return
        case .RequestError:
            errorText = "Network request Error!"
            break
        case .ResponseWrongStatus:
            errorText = "Network response does not have expected status!"
            break
        case .NoData:
            errorText = "No data responsed from server!"
            break
        case .ParseJSONError:
            errorText = "Data cannot be parsed!"
            break
        }
        viewController.showAlert(errorText)
    }
}
