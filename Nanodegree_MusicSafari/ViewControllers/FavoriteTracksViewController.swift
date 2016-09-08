//
//  AlbumDetailViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/29/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import CoreData

class FavoriteTracksViewController: CoreDataTableViewController {

    var likedDataHelper : LikedDataHelper?
    var musicPlayerInstance = MusicPlayerFactory.defaultInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayerInstance.registerDelegate(self)
        
        
        let fr = NSFetchRequest(entityName: String(LikedItem.self))
        fr.predicate = NSPredicate(format: "type == %@", argumentArray: [LikedItem.ItemType.Track.rawValue])
        fr.sortDescriptors = [NSSortDescriptor(key:"createdDate", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getUserStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        musicPlayerInstance.removeDelegate(self)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackTableViewCell ,
            let likedItem = cell.data as? LikedItem{
                if (musicPlayerInstance.enabled) {
                    if (likedItem.id == musicPlayerInstance.currentTrack?.id) {
                        musicPlayerInstance.pause()
                    } else {
                        playLikedItem(likedItem)
                    }
                } else {
                    showAlert("Only Premium member of Spotify can play track.")
                }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCellWithIdentifier("trackTableCell") as? TrackTableViewCell
        if let likedItem = fetchedResultsController?.objectAtIndexPath(indexPath) as? LikedItem {
            item!.data = likedItem
            item!.name = likedItem.name
            item!.playEnabled = musicPlayerInstance.enabled
            
            if item!.playEnabled {
                item!.playing = musicPlayerInstance.currentTrack?.id == likedItem.id && musicPlayerInstance.isPlaying
            }
            
            item!.liked = true
            item!.likePressedCallback = likeCallback
        }
        return item!
    }
    
    func likeCallback(cell: TrackTableViewCell) -> Void {
        if let likedItem = cell.data as? LikedItem {
            likedItem.managedObjectContext?.deleteObject(likedItem)
        }
    }
    
    func onLikedDataChanged() -> Void {
        tableView.reloadData()
    }
    
    func playLikedItem(item:LikedItem) {
        TrackAPI.getTracksById([item.id!], context:CoreDataHelper.getLibraryStack().context) { (result) -> Void in
            if let track = result[item.id!] as? Track {
                self.musicPlayerInstance.playTrack(track)
            }
        }
        
    }
}

extension FavoriteTracksViewController : MusicPlayerDelegate {
    func onTrackPlayStarted(track: Track) {
        tableView.reloadData()
    }
    
    func onTrackPaused(track: Track) {
        tableView.reloadData()
    }
    
    func onPlaybackStatusChanged(playing: Bool) {
        tableView.reloadData()
    }
}
