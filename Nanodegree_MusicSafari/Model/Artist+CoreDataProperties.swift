//
//  Artist+CoreDataProperties.swift
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

extension Artist {

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var popularity: NSNumber?
    @NSManaged var uri: String?
    @NSManaged var rAlbums: NSSet?
    @NSManaged var rImage: ImageCollection?
    @NSManaged var rSimilarArtists: NSSet?

}
