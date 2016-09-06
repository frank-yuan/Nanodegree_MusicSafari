//
//  LikedItem+CoreDataProperties.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/6/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LikedItem {

    @NSManaged var createdDate: NSDate?
    @NSManaged var id: String?
    @NSManaged var type: NSNumber?

}
