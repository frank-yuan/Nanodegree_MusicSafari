//
//  FirstViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fr = NSFetchRequest(entityName: "Artist")
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let busyView = BusyView(parent: view)
        view.addSubview(busyView)
        ArtistManager.searchArtist("Mayer", context: (fetchedResultsController?.managedObjectContext)!){ result -> Void in
            busyView.removeFromSuperview()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCellWithIdentifier("artistTableCell") as? ArtistTableViewCell
        if let artist = fetchedResultsController?.objectAtIndexPath(indexPath) as? Artist {
            item!.artist = artist
            item!.textLabel!.text = item!.artist!.name
            if let image = artist.imageSmall {
                item!.imageView?.image = UIImage(data: image)
            } else {
                item!.imageView?.image = UIImage(named: "question")
                artist.downloadImage(Artist.ImageSize.Small)
            }
        }
        return item!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("ArtistDetailViewController") as? ArtistDetailViewController {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? ArtistTableViewCell
            vc.artist = cell?.artist
            if vc.artist?.imageLarge == nil {
                vc.artist?.downloadImage(Artist.ImageSize.Large) {
                    performUIUpdatesOnMain{
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }

}

