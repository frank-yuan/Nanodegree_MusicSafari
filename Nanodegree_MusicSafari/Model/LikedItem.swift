//
//  LikedItem.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/6/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class LikedItem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    enum ItemType:Int {
        case Track = 0,
        Album,
        Artist
    }
    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(LikedItem.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
}
