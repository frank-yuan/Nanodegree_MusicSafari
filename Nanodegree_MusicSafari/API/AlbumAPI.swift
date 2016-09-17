//
//  AlbumAPI.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class AlbumAPI: NSObject {

    static func getArtistTopAlbums(artistId:String, context:NSManagedObjectContext, completionHandler: ((NetworkError, [String : AnyObject?]?)->Void)?) {
        guard let artist = CoreDataHelper.fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: [artistId], from: context).first as? Artist else {
            return
        }
        let request = try! SPTArtist.createRequestForAlbumsByArtist(NSURL(string: artist.uri!), ofType: .Album, withAccessToken: SPTAuth.defaultInstance().session.accessToken, market: nil)
        
        HttpService.service(request) { (data, error) in
            guard error == .Succeed else {
                if let completionHandler = completionHandler{
                    completionHandler(error, nil)
                }
                return
            }
            
            HttpServiceHelper.parseJSONResponse(data, error: error) { (result, error) in
                var dic = [String : AnyObject?]()
                if error == .Succeed {
                    let albums = AnyObjectHelper.parseWithDefault(result, name: "items", defaultValue: NSArray())
                    var keys = [String]()
                    var idToJSONObjectMap = [String : AnyObject?]()
                    for item in albums {
                        let id = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                        if (id.characters.count > 0) {
                            keys.append(id)
                            idToJSONObjectMap[id] = AnyObjectHelper.parse(item, name: "images")
                        }
                    }
                    
                    context.performBlock{
                        let managedResult = CoreDataHelper.fetchManagedObject(String(Album.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                        var dictForImageArray = [NSManagedObject : NSArray]()
                        
                        for obj in managedResult  {
                            if let album = obj as? Album {
                                dic[album.id!] = album
                            }
                        }
                        
                        for item in albums {
                            let key = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                            if key.characters.count > 0 {
                                var album = dic[key] as? Album
                                if album == nil {
                                    album = Album(context: context)
                                    dic[key] = album
                                }
                                album!.updateWith(spotify: item)
                                album!.rArtist = artist
                                
                                // prepare for image array
                                if let dataToParse = idToJSONObjectMap[key] as? NSArray {
                                    dictForImageArray[album!] = dataToParse
                                }
                            }
                        }
                        
                        SpotifyDataHelper.initImageCollectionFor(dictForImageArray, within: context)
                        
                    }
                }
                if let completionHandler = completionHandler{
                    completionHandler(error, dic)
                }
            }
        }
    }
    
}
