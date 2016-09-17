//
//  ArtistSearchViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/28/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData
import UIKit

class ArtistSearchViewController: CoreDataTableViewController {

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCellWithIdentifier("artistTableCell") as? ArtistTableViewCell
        if let artist = fetchedResultsController?.objectAtIndexPath(indexPath) as? Artist {
            item!.artist = artist
            item!.artistName!.text = item!.artist!.name
            item!.artistImage!.image = UIImage(named: "question")
            
            guard let imageCollection = artist.rImage else {
                return item!
            }
            
            if let imageData = imageCollection.dataSmall {
                
                item!.artistImage!.image = UIImage(data: imageData)
                
            } else {
                imageCollection.downloadImage(.Small) { (data:NSData) -> Void in
                    self.fetchedResultsController?.managedObjectContext.performBlock({
                        // set time to trigger update
                        artist.lastUpdatedTimeStamp = NSDate(timeIntervalSinceNow: 0)
                    })
                }
            }
        }
        return item!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("ArtistDetailViewController") as? ArtistDetailViewController {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? ArtistTableViewCell {
                let artist = cell.artist
                vc.artist = artist
                let id = artist!.id!
                
                let fr = NSFetchRequest(entityName: String(Album.self))
                fr.predicate = NSPredicate(format: "rArtist = %@", argumentArray: [artist!])
                fr.sortDescriptors = [NSSortDescriptor(key:"releasedDate", ascending: true)]
                
                if vc.fetchedResultsController?.fetchedObjects?.count > 0 {
                    let workerContext = fetchedResultsController?.managedObjectContext
                    AlbumAPI.getArtistTopAlbums(id, context: workerContext!, completionHandler: nil)
                    vc.fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let rootView = UIHelper.getRootViewController(from: self).view
                    let busyView = BusyView(parent: rootView)
                    view.addSubview(busyView)
                    
                    let workerContext = fetchedResultsController?.managedObjectContext
                    AlbumAPI.getArtistTopAlbums(id, context: workerContext!) { error, result in
                        performUIUpdatesOnMain({ 
                            busyView.removeFromSuperview()
                            if error != .Succeed {
                                HttpServiceHelper.showErrorAlert(error, forViewController: self)
                            } else {
                                vc.fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        })
                        
                    }
                    
                }
                
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIConstants.ArtistSearch.CellHeight
    }
    
    func startSearch(name:String) {
        
        let rootView = parentViewController?.parentViewController?.parentViewController?.view
        let busyView = BusyView(parent: rootView!)
        rootView!.addSubview(busyView)
        
        let fr = NSFetchRequest(entityName: "Artist")
        fr.predicate = NSPredicate(format: "name contains %@", argumentArray: [name])
        fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        ArtistAPI.searchArtist(name, context: (fetchedResultsController?.managedObjectContext)!){ error, result -> Void in
            busyView.removeFromSuperview()
            HttpServiceHelper.showErrorAlert(error, forViewController: self)
        }
    }
}

extension ArtistSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        startSearch(searchBar.text!)
    }
    
}
