//
//  LikedDataHelper.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/6/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class LikedDataHelper: NSObject {
    var fetchedResultController : NSFetchedResultsController? {
        didSet {
            fetchedResultController!.delegate = self
            executeSearch()
            syncResultSet()
        }
    }
    
    private var likedResultsMap = [String : LikedItem]()
    
    func checkLiked(id:String) -> Bool{
        return likedResultsMap.keys.contains(id)
    }
    
    var didChangedCallback : (() -> Void)?
    
    func setLiked(id:String, liked:Bool) {
        if let fetchedResultController = fetchedResultController {
            let context = fetchedResultController.managedObjectContext
            context.performBlock({ () -> Void in
                let currentLiked = self.checkLiked(id)
                if liked && !currentLiked{
                    let newRecord = LikedItem(context: context)
                    newRecord.id = id
                    newRecord.type = LikedItem.ItemType.Track.rawValue
                    newRecord.createdDate = NSDate(timeIntervalSinceNow: 0)
                } else if !liked && currentLiked{
                    context.deleteObject(self.likedResultsMap[id]!)
                    self.likedResultsMap.removeValueForKey(id)
                }
            })
        }
    }
    
    private func executeSearch() {
        if let fetchedResultController = fetchedResultController {
            do {
                try fetchedResultController.performFetch()
            } catch {
                print("Fail to fetch")
            }
        }
    }
    
    private func syncResultSet() {
        
        likedResultsMap.removeAll()
        if let fetchedResultController = fetchedResultController {
            if let results = fetchedResultController.fetchedObjects {
                for result in results {
                    if let likeRecord = result as? LikedItem {
                        likedResultsMap[likeRecord.id!] = likeRecord
                    }
                }
            }
        }
    }
    
}

extension LikedDataHelper : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        syncResultSet()
        if let callback = didChangedCallback {
            callback()
        }
    }
}
