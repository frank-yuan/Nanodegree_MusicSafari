//
//  LastfmAPI.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class LastfmAPI: NSObject {

    struct LastfmAPIConfig : APIConfig {
        
        var ApiScheme: String { return Constants.Lastfm.APIScheme }
        var ApiHost: String { return Constants.Lastfm.APIHost }
        var ApiPath: String { return Constants.Lastfm.APIPath }
    }
    
    private static let config = LastfmAPIConfig()
    
    static func searchArtists(keyword:String, page:Int = 1, limit:Int = 30, completionHandler:(result:AnyObject?, error:NetworkError)-> Void ) {
        
        let methodParameters = [
            Constants.LastfmParameterKeys.Method: Constants.LastfmParameterArtist.Search,
            Constants.LastfmParameterKeys.APIKey: Constants.LastfmParameterValues.APIKey,
            Constants.LastfmParameterKeys.Format: Constants.LastfmParameterValues.ResponseFormat,
            Constants.LastfmParameterKeys.Page: "\(page)",
            Constants.LastfmParameterKeys.Limit: "\(limit)",
            Constants.LastfmParameterArtist.Artist: keyword
        ]
        
        if let url = HttpServiceHelper.buildURL(config, withPathExtension: "", queryItems: methodParameters)
        {
            
            let request = HttpRequest(url: url)
            HttpService.service(request) { (data, error) in
                if let data = data where error == NetworkError.Succeed {
                    HttpServiceHelper.parseJSONResponse(data, error: error) { (result, error) in
                        completionHandler(result:result, error:error)
                    }
                }else {
                    completionHandler(result:data, error:error)
                }
            }
        }
    }
}
