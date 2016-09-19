//
//  Album+CoreDataProperties.swift
//  
//
//  Created by Xuan Yuan on 2016-09-18.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Album {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var releasedDate: NSDate?
    @NSManaged var uri: String?
    @NSManaged var rArtist: Artist?
    @NSManaged var rImage: ImageCollection?
    @NSManaged var rTracks: NSSet?

}
