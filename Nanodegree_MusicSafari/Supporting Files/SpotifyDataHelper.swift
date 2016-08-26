//
//  SpotifyDataHelper.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/25/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class SpotifyDataHelper: NSObject {
    static func parseImageArray(data:NSArray?) -> [SPTImage] {
        var result = [SPTImage]()
        if let data = data {
            for item in data {
                do {
                    result.append(try SPTImage(fromDecodedJSON: item))
                } catch {
                }
                result.sortInPlace({ (left, right) -> Bool in
                    return left.size.width < right.size.width
                })
            }
        }
        return result
    }
    
    static func initArtist(artist:Artist,withSpotifyData data:AnyObject) {
        do {
            let spotifyArtist = try SPTArtist(decodedJSONObject: data)
            
            artist.id = spotifyArtist.identifier
            artist.name = spotifyArtist.name
            artist.uri = spotifyArtist.uri.absoluteString
        } catch {
            
        }
    }
    
    static func initImageCollectionById(id:String, withSpotifyData data:AnyObject, inContex: NSManagedObjectContext, completionHandler:((updated:Bool, image:ImageCollection)->Void)?) {
    }
    
}

//public protocol DataWithTimeStamp {
//    var lastUpdatedTimeStamp:NSDate? {get set}
//}
//
//extension Artist : DataWithTimeStamp {
//    var lastUpdatedTimeStamp : NSDate?
//    {
//        get{return updatedTimeStamp}
//        set(v) {updatedTimeStamp = v}
//    }
//}
//
//extension Album : DataWithTimeStamp {
//    var lastUpdatedTimeStamp : NSDate?
//    {
//        get{return updatedTimeStamp}
//        set(v) {updatedTimeStamp = v}
//    }
//}