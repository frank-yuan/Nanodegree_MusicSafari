//
//  AlbumDetailViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class AlbumDetailViewController: CoreDataTableViewController {

    @IBOutlet weak var portrait:UIImageView!
    var album : Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = album?.name
        
        if let imageCollection = album?.rImage {
            
            if let imageData = imageCollection.dataLarge{
                portrait.image = UIImage(data:imageData)
            } else {
                imageCollection.downloadImage(.Large) {
                    performUIUpdatesOnMain({ 
                        if let imageData = imageCollection.dataLarge{
                            self.portrait.image = UIImage(data:imageData)
                        }
                    })
                }
            }
            
        }
        
        let id = album!.id!
        
        let fr = NSFetchRequest(entityName: String(Track.self))
        fr.predicate = NSPredicate(format: "rAlbum == %@", argumentArray: [album!])
        fr.sortDescriptors = [NSSortDescriptor(key:"discNum", ascending: true), NSSortDescriptor(key:"trackNum", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        let workerContext = fetchedResultsController?.managedObjectContext
        TrackAPI.getTracksByAlbum(id, context: workerContext!){ result -> Void in
            performUIUpdatesOnMain({ 
                self.executeSearch()
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCellWithIdentifier("trackTableCell") as? TrackTableViewCell
        if let track = fetchedResultsController?.objectAtIndexPath(indexPath) as? Track {
            item!.setTrack(track)
        }
        return item!
    }
}
