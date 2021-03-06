//
//  ImageCollection+CoreDataProperties.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ImageCollection {

    @NSManaged var dataLarge: NSData?
    @NSManaged var dataMedium: NSData?
    @NSManaged var dataSmall: NSData?
    @NSManaged var id: String?
    @NSManaged var urlLarge: String?
    @NSManaged var urlMedium: String?
    @NSManaged var urlSmall: String?

}
