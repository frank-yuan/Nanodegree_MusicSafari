//
//  Artist.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import Foundation
import CoreData


class Artist: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    convenience init(dictionary:AnyObject?, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(Artist.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            update(dictionary)
        } else {
            fatalError("Unable to find entity Artist")
        }
    }
    
    func update(dictionary:AnyObject?) {
        
        self.id = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.ID, defaultValue: "Invalid")
        self.name = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.Name, defaultValue: "")
        let images = AnyObjectHelper.parseWithDefault(dictionary, name: Constants.LastfmResponseKeys.Image, defaultValue: NSArray())
        for image in images {
            let size = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.Size, defaultValue: "")
            if size == Constants.LastfmResponseValues.Medium {
                self.imageMedium = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            } else if size == Constants.LastfmResponseValues.Large {
                self.imageLarge = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            }
        }
    }
    

}
