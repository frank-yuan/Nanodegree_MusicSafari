//
//  ImageCollection.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/26/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class ImageCollection: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(ImageCollection.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
}
