//
//  Artist+CoreDataProperties.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/26/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Artist {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var popularity: NSNumber?
    @NSManaged var uri: String?
    @NSManaged var updatedTimeStamp: NSDate?
    @NSManaged var rAlbums: NSSet?
    @NSManaged var rSimilarArtists: NSSet?
    @NSManaged var rTracks: NSSet?
    @NSManaged var rImage: ImageCollection?

}
