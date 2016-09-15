//
//  Track+CoreDataProperties.swift
//  
//
//  Created by Xuan Yuan on 2016-09-15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Track {

    @NSManaged var discNum: NSNumber?
    @NSManaged var duration: NSNumber?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var trackNum: NSNumber?
    @NSManaged var uri: String?
    @NSManaged var playable: NSNumber?
    @NSManaged var rAlbum: Album?

}
