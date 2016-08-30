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


    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Album.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
    
}
extension Album{

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
