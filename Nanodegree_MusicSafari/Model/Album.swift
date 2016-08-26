//
//  Album.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class Album: NSManagedObject {

    enum ImageSize{
        case Small,
        Large
    }

    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Album.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
    
    convenience init(dictionary:AnyObject?, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Album.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            update(dictionary)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
    
    func update(dictionary:AnyObject?) {
        
        self.id = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.ID, defaultValue: "Invalid")
        self.name = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.Name, defaultValue: "")
        let artist = AnyObjectHelper.parse(dictionary, name: Constants.LastfmResponseKeys.AlbumArtistKey)
        let artistId = AnyObjectHelper.parseWithDefault(artist, name: Constants.LastfmResponseKeys.ID, defaultValue: "")
        if artistId.characters.count > 0 {
            let fr = NSFetchRequest(entityName: String(Artist.self))
            fr.predicate = NSPredicate(format: "id = %@", argumentArray: [artistId])
            fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            let artistResult = try! self.managedObjectContext?.executeFetchRequest(fr)
            if artistResult?.count > 0 {
                self.rArtist = artistResult!.first as? Artist
            } else {
                let artist = Artist(dictionary: artist, context: self.managedObjectContext!)
                self.rArtist = artist
            }
        }
    }
    
    func updateWith(spotify album:AnyObject) {
        do {
            let spotifyAlbum = try SPTAlbum(decodedJSONObject: album)
            id = spotifyAlbum.identifier
            name = spotifyAlbum.name
            releasedDate = spotifyAlbum.releaseDate
        } catch {
            
        }
    }
    
}
