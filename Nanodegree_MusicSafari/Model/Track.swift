//
//  Track.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class Track: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Track.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }

}

extension Track{
    func updateWith(spotify artist:AnyObject) {
        do {
            let spotifyTrack = try SPTTrack(decodedJSONObject: artist)
            id = spotifyTrack.identifier
            name = spotifyTrack.name
            uri = spotifyTrack.uri.absoluteString
            trackNum = NSNumber(integer: AnyObjectHelper.parseWithDefault(artist, name: "track_number", defaultValue: 0))
            discNum = NSNumber(integer: AnyObjectHelper.parseWithDefault(artist, name: "disc_number", defaultValue: 1))
        } catch {
        }
    }
}