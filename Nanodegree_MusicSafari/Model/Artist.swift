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

    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Artist.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Artist")
        }
    }
}

extension Artist{
    func updateWith(spotify artist:AnyObject) {
        do {
            let spotifyArtist = try SPTArtist(decodedJSONObject: artist)
            id = spotifyArtist.identifier
            name = spotifyArtist.name
            uri = spotifyArtist.uri.absoluteString
        } catch {
        }
    }
    
}


