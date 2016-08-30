//
//  ArtistAPI.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/19/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData

class ArtistAPI: NSObject {

    static func searchArtist(name:String, context:NSManagedObjectContext, completionHandler: (([String : AnyObject?])->Void)?) {
        
        let request = try! SPTSearch.createRequestForSearchWithQuery(name, queryType: .QueryTypeArtist, accessToken: SPTAuth.defaultInstance().session.accessToken)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            HttpServiceHelper.parseJSONResponse(data, error: .Succeed, completeHandler: { (result, error) in
                let items = AnyObjectHelper.parseWithDefault(result, name: "artists.items", defaultValue: NSArray())
                var idToJSONObjectMap = [String : AnyObject?]()
                var keys = [String]()
                for item in items {
                    let id = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                    if (id.characters.count > 0) {
                        keys.append(id)
                    }
                    idToJSONObjectMap[id] = AnyObjectHelper.parse(item, name: "images")
                }
                
                context.performBlock{
                    let managedResult = CoreDataHelper.fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                    var existArtists = [String : Artist]()
                    var dictForImageArray = [NSManagedObject : NSArray]()
                    
                    // map all exist artist with id
                    for obj in managedResult  {
                        if let artist = obj as? Artist {
                            existArtists[artist.id!] = artist
                        }
                    }
                    
                    for item in items {
                        let key = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                        var artist = existArtists[key]
                        
                        // update exist, or create new and put them into map
                        if (artist == nil) {
                            artist = Artist(context: context)
                            existArtists[key] = artist
                        }
                        
                        artist!.updateWith(spotify: item)
                        
                        // prepare for image array
                        if let dataToParse = idToJSONObjectMap[key] as? NSArray {
                            dictForImageArray[artist!] = dataToParse
                        }
                    }
                    
                    SpotifyDataHelper.initImageCollectionFor(dictForImageArray, within: context)
                    
                    if let completionHandler = completionHandler{
                        completionHandler(existArtists)
                    }
                }
            })
        }
        task.resume()
    }
    
    private static func parseIndexArrayFromResult(responseArray:NSArray, indexNameOfResponse:String) -> [String]{
        var keys = [String]()
        for item in responseArray {
            let key = AnyObjectHelper.parseWithDefault(item, name: indexNameOfResponse, defaultValue: "")
            if key.characters.count > 0{
                keys.append(key)
            }
        }
        return keys
    }
    
}
