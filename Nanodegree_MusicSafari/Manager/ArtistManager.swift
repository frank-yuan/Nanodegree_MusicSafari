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
        
        LastfmAPI.searchArtists(name) { (result, error) in
            let result = AnyObjectHelper.parseWithDefault(result, name: Constants.LastfmParameterArtist.SearchResultKey, defaultValue: NSArray())
            
            context.performBlock{
                let keys = parseIndexArrayFromResult(result, indexNameOfResponse: Constants.LastfmResponseKeys.ID)
                let managedResult = fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                var dic = [String : AnyObject?]()
                
                for obj in managedResult  {
                    if let artist = obj as? Artist {
                        dic[artist.id!] = artist
                    }
                }
                
                for item in result {
                    let key = AnyObjectHelper.parseWithDefault(item, name: Constants.LastfmResponseKeys.ID, defaultValue: "")
                    if key.characters.count > 0{
                        if let artist = dic[key] as? Artist {
                            artist.update(item)
                        } else {
                            dic[key] = Artist(dictionary: item, context: context)
                        }
                    }
                }
                
                if let completionHandler = completionHandler{
                    completionHandler(dic)
                }
            }
        }
    }
    
    static func getArtistTopAlbums(artistId:String, context:NSManagedObjectContext, completionHandler: (([String : AnyObject?])->Void)?) {
        LastfmAPI.getAlbumsOfTheArtist(artistId) { (result, error) in
            let result = AnyObjectHelper.parseWithDefault(result, name: Constants.LastfmParameterArtist.GetTopAlbumsResultKey, defaultValue: NSArray())
            
            context.performBlock{
                let keys = parseIndexArrayFromResult(result, indexNameOfResponse: Constants.LastfmResponseKeys.ID)
                let managedResult = fetchManagedObject(String(Artist.self), indexNameOfManagedObject: "id", byIndexArray: keys, from: context)
                var dic = [String : AnyObject?]()
                
                for obj in managedResult  {
                    if let album = obj as? Album {
                        dic[album.id!] = album
                    }
                }
                
                for item in result {
                    let key = AnyObjectHelper.parseWithDefault(item, name: Constants.LastfmResponseKeys.ID, defaultValue: "")
                    if key.characters.count > 0{
                        if let album = dic[key] as? Album{
                            album.update(item)
                        } else {
                            dic[key] = Album(dictionary: item, context: context)
                        }
                    }
                }
                
                if let completionHandler = completionHandler{
                    completionHandler(dic)
                }
            }
        }
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
        fetchRequest.predicate = NSPredicate(format: "\(indexNameOfManagedObject) IN %@", argumentArray: indexArray)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: indexNameOfManagedObject, ascending: true)]
        
        return try! context.executeFetchRequest(fetchRequest)
    }
}
