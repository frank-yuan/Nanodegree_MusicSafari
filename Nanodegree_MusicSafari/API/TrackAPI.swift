//
//  TrackAPI.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class TrackAPI: NSObject {
    
    static func getTracksById(trackIds:[String], context:NSManagedObjectContext, completionHandler: (([String: AnyObject?])->Void)?) {
        
        var mutableTrackIds = trackIds
        var result = [String:AnyObject?]()
        
        let fetchedResults = CoreDataHelper.fetchManagedObject(String(Track.self), indexNameOfManagedObject: "id", byIndexArray: mutableTrackIds, from: context)
        
        for item in fetchedResults {
            if let track = item as? Track {
                result[track.id!] = track
            }
        }
        for i in (0 ... mutableTrackIds.count - 1).reverse(){
            let id = mutableTrackIds[i]
            if nil != result[id] {
                mutableTrackIds.removeAtIndex(i)
            }
        }
        if mutableTrackIds.count == 0 {
            if let completionHandler = completionHandler {
                completionHandler(result)
            }
        } else {
            let request = try! SPTTrack.createRequestForTracks(mutableTrackIds, withAccessToken: SPTAuth.defaultInstance().session.accessToken, market: nil)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
                HttpServiceHelper.parseJSONResponse(data, error: .Succeed, completeHandler: { (data, error) in
                    let tracks = AnyObjectHelper.parseWithDefault(data, name: "tracks", defaultValue: NSArray())
                    
                    context.performBlock{
                        
                        for item in tracks {
                            let key = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                            if key.characters.count > 0 {
                                let track = Track(context: context)
                                track.updateWith(spotify: item)
                                result[key] = track
                            }
                        }
                        
                        CoreDataHelper.getLibraryStack().save()
                        
                        if let completionHandler = completionHandler{
                            completionHandler(result)
                        }
                    }
                })
            }
            task.resume()
        }
    }

    static func getTracksByAlbum(albumId:String, context:NSManagedObjectContext, completionHandler: (([String : AnyObject?])->Void)?) {
        guard let album = CoreDataHelper.fetchManagedObject(String(Album.self), indexNameOfManagedObject: "id", byIndexArray: [albumId], from: context).first as? Album else {
            return
        }
        let request = try! SPTRequest.createRequestForURL(NSURL(string:"https://api.spotify.com/v1/albums/\(albumId)/tracks"),
					  withAccessToken:SPTAuth.defaultInstance().session.accessToken,
						   httpMethod:"get",
							   values:nil,
					  valueBodyIsJSON:false,
				sendDataAsQueryString:true)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            HttpServiceHelper.parseJSONResponse(data, error: .Succeed, completeHandler: { (result, error) in
                let tracks = AnyObjectHelper.parseWithDefault(result, name: "items", defaultValue: NSArray())
                var keys = [String]()
                for item in tracks {
                    let id = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                    if (id.characters.count > 0) {
                        keys.append(id)
                    }
                }
                
                context.performBlock{
                    let managedResult = CoreDataHelper.fetchManagedObject(String(Track.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                    var dic = [String : AnyObject?]()
                    
                    for obj in managedResult  {
                        if let track = obj as? Track {
                            dic[track.id!] = track
                        }
                    }
                    
                    for item in tracks {
                        let key = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                        if key.characters.count > 0 {
                            var track = dic[key] as? Track
                            if track == nil {
                                track = Track(context: context)
                                dic[key] = track
                            }
                            track!.updateWith(spotify: item)
                            track!.rAlbum = album
                            
                            // update album track
                            if let mutableSet = album.rTracks as? NSMutableSet {
                                mutableSet.addObject(track!)
                            }
                            
                        }
                    }
                    
                    CoreDataHelper.getLibraryStack().save()
                    
                    if let completionHandler = completionHandler{
                        completionHandler(dic)
                    }
                }
            })
        }
        task.resume()
    }
}
