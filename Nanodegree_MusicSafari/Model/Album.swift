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
        let images = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.Image, defaultValue: NSArray())
        for image in images {
            let size = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.Size, defaultValue: "")
            if size == Constants.LastfmResponseValues.Large {
                self.imageURLLarge = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            } else if size == Constants.LastfmResponseValues.Small {
                self.imageURLSmall = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            }
        }
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
            
            let images = SpotifyDataHelper.parseImageArray(AnyObjectHelper.parseWithDefault(album, name: "images", defaultValue: NSArray()))
            self.imageURLSmall = images.first?.imageURL.absoluteString
            self.imageURLLarge = images.last?.imageURL.absoluteString
            
        } catch {
            
        }
    }
    
    func parseImage(hashtable:AnyObject) {
        
    }
    func getImageURLBySize(size:ImageSize) -> String? {
        switch size{
        case .Large:
            return imageURLLarge
        case .Small:
            return imageURLSmall
        }
    }
    
    func setImageBySize(data:NSData, size:ImageSize) {
        switch size{
        case .Large:
            imageLarge = data
        case .Small:
            imageSmall = data
        }
    }
    
    func downloadImage(size:ImageSize, completionHandler:(()->Void)? = nil) {
        if let imageURL = getImageURLBySize(size) {
            performUpdatesUserInteractive{
                if let data = NSData(contentsOfURL: NSURL(string: imageURL)!) {
                    self.managedObjectContext?.performBlock{
                        self.setImageBySize(data, size: size)
                        if let handler = completionHandler {
                            handler()
                        }
                    }
                }
            }
        }
    }
}
