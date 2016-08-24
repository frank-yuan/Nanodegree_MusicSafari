//
//  ArtistManager.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/19/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData

class ArtistManager: NSObject {

    static func searchArtist(name:String, context:NSManagedObjectContext, completionHandler: (([String : AnyObject?])->Void)?) {
        
        let request = try! SPTSearch.createRequestForSearchWithQuery(name, queryType: .QueryTypeArtist, accessToken: SPTAuth.defaultInstance().session.accessToken)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            HttpServiceHelper.parseJSONResponse(data, error: .Succeed, completeHandler: { (result, error) in
                let items = AnyObjectHelper.parseWithDefault(result, name: "artists.items", defaultValue: NSArray())
                var artists = [SPTArtist]()
                var keys = [String]()
                for item in items {
                    do {
                        let artist = try SPTArtist(decodedJSONObject: item)
                        let id = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                        if (id.characters.count > 0) {
                            keys.append(id)
                        }
                        artists.append(artist)
                    } catch {
                    }
                }
            context.performBlock{
                let managedResult = fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                var dic = [String : AnyObject?]()
                
                for obj in managedResult  {
                    if let artist = obj as? Artist {
                        dic[artist.id!] = artist
                    }
                }
                
                for item in artists {
                    let key = item.identifier
                    if let artist = dic[key] as? Artist {
                        artist.updateWith(item)
                    } else {
                        let artist = Artist(context: context)
                        artist.updateWith(item)
                        dic[key] = artist
                    }
                }
                
                if let completionHandler = completionHandler{
                    completionHandler(dic)
                }
            }
            })
        }
        task.resume()
        
//        LastfmAPI.searchArtists(name) { (result, error) in
//            let result = AnyObjectHelper.parseWithDefault(result, name: Constants.LastfmParameterArtist.SearchResultKey, defaultValue: NSArray())
//            
//            context.performBlock{
//                let keys = parseIndexArrayFromResult(result, indexNameOfResponse: Constants.LastfmResponseKeys.ID)
//                let managedResult = fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
//                var dic = [String : AnyObject?]()
//                
//                for obj in managedResult  {
//                    if let artist = obj as? Artist {
//                        dic[artist.id!] = artist
//                    }
//                }
//                
//                for item in result {
//                    let key = AnyObjectHelper.parseWithDefault(item, name: Constants.LastfmResponseKeys.ID, defaultValue: "")
//                    if key.characters.count > 0{
//                        if let artist = dic[key] as? Artist {
//                            artist.update(item)
//                        } else {
//                            dic[key] = Artist(dictionary: item, context: context)
//                        }
//                    }
//                }
//                
//                if let completionHandler = completionHandler{
//                    completionHandler(dic)
//                }
//            }
//        }
    }
    
    static func getArtistTopAlbums(artistId:String, context:NSManagedObjectContext, completionHandler: (([String : AnyObject?])->Void)?) {
        guard let artist = Artist.getObjectInContext(context, byId: artistId) else {
            return
        }
        let request = try! SPTArtist.createRequestForAlbumsByArtist(NSURL(string: artist.uri!), ofType: .Album, withAccessToken: SPTAuth.defaultInstance().session.accessToken, market: nil)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            HttpServiceHelper.parseJSONResponse(data, error: .Succeed, completeHandler: { (result, error) in
                let albums = AnyObjectHelper.parseWithDefault(result, name: "items", defaultValue: NSArray())
                var keys = [String]()
                for item in albums {
                    let id = AnyObjectHelper.parseWithDefault(item, name: "id", defaultValue: "")
                    if (id.characters.count > 0) {
                        keys.append(id)
                    }
                }
            context.performBlock{
                let managedResult = fetchManagedObject(String(Album.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                var dic = [String : AnyObject?]()
                
                for obj in managedResult  {
                    if let artist = obj as? Artist {
                        dic[artist.id!] = artist
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
                    }
                }
                
//            var spotifyArtists = [SPTArtist]()
//            for artist in spotifyAlbum.artists {
//                spotifyArtists.append(SPTArtist(decodedJSONObject: artist))
//            }
                if let completionHandler = completionHandler{
                    completionHandler(dic)
                }
            }
            })
        }
        task.resume()
//        LastfmAPI.getAlbumsOfTheArtist(artistId) { (result, error) in
//            let result = AnyObjectHelper.parseWithDefault(result, name: Constants.LastfmParameterArtist.GetTopAlbumsResultKey, defaultValue: NSArray())
//            
//            context.performBlock{
//                let keys = parseIndexArrayFromResult(result, indexNameOfResponse: Constants.LastfmResponseKeys.ID)
//                let managedResult = fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
//                var dic = [String : AnyObject?]()
//                
//                for obj in managedResult  {
//                    if let album = obj as? Album {
//                        dic[album.id!] = album
//                    }
//                }
//                
//                for item in result {
//                    let key = AnyObjectHelper.parseWithDefault(item, name: Constants.LastfmResponseKeys.ID, defaultValue: "")
//                    if key.characters.count > 0{
//                        if let album = dic[key] as? Album{
//                            album.update(item)
//                        } else {
//                            dic[key] = Album(dictionary: item, context: context)
//                        }
//                    }
//                }
//                
//                if let completionHandler = completionHandler{
//                    completionHandler(dic)
//                }
//            }
//        }
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
    
    private static func fetchManagedObject(entityName:String, indexNameOfManagedObject:String, byIndexArray indexArray: [String], from context:NSManagedObjectContext) -> [AnyObject]{
        
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(indexNameOfManagedObject) IN %@", argumentArray: [indexArray])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: indexNameOfManagedObject, ascending: true)]
        
        do{
            return try context.executeFetchRequest(fetchRequest)
        } catch {
            return [AnyObject]()
        }
    }
}
