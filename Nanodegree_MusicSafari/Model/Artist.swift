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
    enum ImageSize{
        case Small,
        Medium
    }

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
                self.imageURLMedium = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            } else if size == Constants.LastfmResponseValues.Small {
                self.imageURLSmall = AnyObjectHelper.parseWithDefault(image, name: Constants.LastfmResponseKeys.URLText, defaultValue: "")
            }
        }
    }
    
    func getImageURLBySize(size:ImageSize) -> String? {
        switch size{
        case .Medium:
            return imageURLMedium
        case .Small:
            return imageURLSmall
        }
    }
    
    func setImageBySize(data:NSData, size:ImageSize) {
        switch size{
        case .Medium:
            imageMedium = data
        case .Small:
            imageSmall = data
        }
    }
    
    func downloadImage(size:ImageSize, completionHandler:(()->Void)? = nil) {
        if let imageURL = getImageURLBySize(size) {
            performUpdatesUserInteractive{
                if let data = NSData(contentsOfURL: NSURL(string: imageURL)!) {
                    self.managedObjectContext?.performBlock{
                        self.setImageBySize(data, size: size)
                        if let handler = completionHandler {
                            handler()
                        }
                    }
                }
            }
        }
    }

}
