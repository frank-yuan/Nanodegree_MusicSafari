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
    var likedDataHelper : LikedDataHelper?
    var musicPlayerInstance = MusicPlayerFactory.defaultInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init like data helper
        let lfr = NSFetchRequest(entityName: String(LikedItem.self))
        lfr.predicate = NSPredicate(format: "type == %@", argumentArray: [LikedItem.ItemType.Track.rawValue])
        lfr.sortDescriptors = [NSSortDescriptor(key:"id", ascending: true)]
        let lfc = NSFetchedResultsController(fetchRequest: lfr, managedObjectContext: CoreDataHelper.getUserStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        likedDataHelper = LikedDataHelper()
        likedDataHelper!.fetchedResultController = lfc
        likedDataHelper!.didChangedCallback = onLikedDataChanged
        
        navigationItem.title = album?.name
        
        // show portrait image or download image
        if let imageCollection = album?.rImage {
            
            if let imageData = imageCollection.dataLarge{
                
                portrait.image = UIImage(data:imageData)
                
            } else {
                
                let busyView = BusyView(parent: portrait)
                portrait.addSubview(busyView)
                
                imageCollection.downloadImage(.Large) { (data:NSData?) -> Void in
                    
                    performUIUpdatesOnMain({
                        
                        busyView.removeFromSuperview()
                        if let data = data {
                            self.portrait.image = UIImage(data:data)
                        } else {
                            self.showAlert("Cannot download portrait image. Check your network!")
                        }
                    })
                    
                }
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        musicPlayerInstance.registerDelegate(self)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        musicPlayerInstance.removeDelegate(self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TrackTableViewCell ,
            let track = cell.data as? Track{
                if (cell.playEnabled) {
                    var playing = false
                    if (track == musicPlayerInstance.currentTrack) {
                        playing = !musicPlayerInstance.isPlaying
                        musicPlayerInstance.isPlaying ? musicPlayerInstance.pause() : musicPlayerInstance.resume()
                    } else {
                        playing = true
                        musicPlayerInstance.playTrack(track)
                    }
                    cell.playing = playing
                } else {
                    showAlert("Only Premium member of Spotify can play track.")
                }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCellWithIdentifier("trackTableCell") as? TrackTableViewCell
        if let track = fetchedResultsController?.objectAtIndexPath(indexPath) as? Track {
            item!.data = track
            if let trackNum = track.trackNum {
                item!.name = "\(trackNum)\t\(track.name!)"
            } else {
                item!.name = track.name
            }
            
            item!.playEnabled = musicPlayerInstance.enabled && track.playable != false
            
            if item!.playEnabled {
                item!.playing = musicPlayerInstance.currentTrack == track && musicPlayerInstance.isPlaying
            }
            
            item!.liked = (likedDataHelper?.checkLiked(track.id!))!
            item!.likePressedCallback = likeCallback
        }
        return item!
    }
    
    func likeCallback(cell: TrackTableViewCell) -> Void {
        if let track = cell.data as? Track {
            likedDataHelper!.setLiked((track.id)!, itemType:LikedItem.ItemType.Track, name:track.name, uri:track.uri, liked: !cell.liked)
        }
    }
    
    func onLikedDataChanged() -> Void {
        tableView.reloadData()
    }
}

extension AlbumDetailViewController : MusicPlayerDelegate {
    func onTrackPlayStarted(track: Track) {
        tableView.reloadData()
    }
    
    func onPlaybackStatusChanged(playing: Bool) {
        tableView.reloadData()
    }
}
