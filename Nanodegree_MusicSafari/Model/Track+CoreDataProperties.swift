//
//  Track+CoreDataProperties.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/24/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var duration: NSNumber?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var track_num: NSNumber?
    @NSManaged var uri: String?
    @NSManaged var imageURLSmall: String?
    @NSManaged var imageURLLarge: String?
    @NSManaged var imageSmall: NSData?
    @NSManaged var imageLarge: NSData?
    @NSManaged var rAlbum: NSSet?
    @NSManaged var rArtist: Artist?

}
