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
    
    static func initImageCollectionFor(objectToImageJSONDataMap:[NSManagedObject:NSArray], within context: NSManagedObjectContext) {
        var ownerDict = [String:ImageOwner]()
        var ownerKeys = [String]()
        for keyValue in objectToImageJSONDataMap {
            if let owner = keyValue.0 as? ImageOwner {
                ownerDict[owner.imageId] = owner
                ownerKeys.append(owner.imageId)
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: String(ImageCollection.self))
        fetchRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [ownerKeys])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let fetchedResult = try context.executeFetchRequest(fetchRequest)
            // remove exist ones
            for item in fetchedResult {
                if let item = item as? ImageCollection {
                    ownerDict.removeValueForKey(item.id!)
                }
            }
            
            // create new
            for keyValue in ownerDict {
                let image = ImageCollection(context: context)
                let owner = keyValue.1 as! NSManagedObject
                let imageData = objectToImageJSONDataMap[owner]
                let spotifyImages = parseImageArray(imageData)
                
                image.id = keyValue.0
                image.urlSmall = spotifyImages.first?.imageURL.absoluteString
                image.urlLarge = spotifyImages.last?.imageURL.absoluteString
                if (spotifyImages.count > 2) {
                    image.urlMedium = spotifyImages[spotifyImages.count - 2].imageURL.absoluteString
                } else {
                    image.urlMedium = image.urlLarge
                }
                // set owner relationship
                if let owner = owner as? ImageOwner {
                    owner.SetImageCollection(image)
                }
            }
        } catch {
            print("Error in initImageCollectionFor")
        }
    }
}

protocol ImageOwner {
    var imageId:String {get}
    func SetImageCollection(imageCollection:ImageCollection)
}

extension Artist : ImageOwner  {
    var imageId : String {
        get {return self.id!}
    }
    func SetImageCollection(imageCollection: ImageCollection) {
        rImage = imageCollection
    }
}

extension Album : ImageOwner {
    var imageId : String {
        get {return self.id!}
    }
    func SetImageCollection(imageCollection: ImageCollection) {
        rImage = imageCollection
    }
}