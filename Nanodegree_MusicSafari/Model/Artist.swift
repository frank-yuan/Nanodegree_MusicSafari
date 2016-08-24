//
//  Artist.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class Artist: NSManagedObject {
    enum ImageSize{
        case Small,
        Large
    }

// Insert code here to add functionality to your managed object subclass
    convenience init(dictionary:AnyObject?, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Artist.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            update(dictionary)
        } else {
            fatalError("Unable to find entity Artist")
        }
    }
    
    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Artist.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Artist")
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

extension Artist{
    func updateWith(spotifyArtist:SPTArtist) {
        id = spotifyArtist.identifier
        name = spotifyArtist.name
        uri = spotifyArtist.uri.absoluteString
        if spotifyArtist.smallestImage != nil {
            imageURLSmall = spotifyArtist.smallestImage.imageURL.absoluteString
        }
        if spotifyArtist.largestImage != nil {
            imageURLLarge = spotifyArtist.largestImage.imageURL.absoluteString
        }
    }
    
    static func getObjectInContext(workerContext:NSManagedObjectContext, byId:String) -> Artist? {
        let fr = NSFetchRequest(entityName: String(Artist.self))
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let pred = NSPredicate(format: "id = %@", argumentArray: [byId])
        fr.predicate = pred
        let fetchResults = try! workerContext.executeFetchRequest(fr)
        if let targetObject = fetchResults.first as? Artist {
            return targetObject
        }
        return nil
    }
}