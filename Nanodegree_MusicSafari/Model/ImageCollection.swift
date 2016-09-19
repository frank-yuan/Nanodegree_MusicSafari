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

    enum ImageSize{
        case Small,
        Medium,
        Large
    }

    convenience init(context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName(String(ImageCollection.self), inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find entity Album")
        }
    }
    
    func getImageURLBySize(size:ImageSize) -> String? {
        switch size{
        case .Large:
            return urlLarge
        case .Medium:
            return urlMedium
        case .Small:
            return urlSmall
        }
    }
    
    func setImageBySize(data:NSData, size:ImageSize) {
        switch size{
        case .Large:
            dataLarge = data
        case .Medium:
            dataMedium = data
        case .Small:
            dataSmall = data
        }
    }
    
    func downloadImage(size:ImageSize, completionHandler:((data:NSData?)->Void)? = nil) {
        if let imageURL = getImageURLBySize(size) {
            performUpdatesUserInteractive{
                if let data = NSData(contentsOfURL: NSURL(string: imageURL)!) {
                    self.managedObjectContext?.performBlock{
                        self.setImageBySize(data, size: size)
                        completionHandler?(data: data)
                    }
                } else {
                    completionHandler?(data: nil)
                }
            }
        }
    }
}

