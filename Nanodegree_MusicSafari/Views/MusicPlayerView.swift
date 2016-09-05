//
//  MusicPlayerView.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/4/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class MusicPlayerView: UIView {

    @IBOutlet weak var playButton : UIButton!
    @IBOutlet weak var trackImage : UIImageView!
    @IBOutlet weak var trackLabel : UILabel!
    
    var enabled : Bool = false{
        didSet{
            playButton.enabled = enabled
            trackLabel.enabled = enabled
        }
    }
}

extension MusicPlayerView : MusicPlayerDelegate {
    
    func didPlayerEnableChanged(enable:Bool) {
        enabled = enable
        
    }
    func onTrackPlayStarted(track:Track) {
        playButton.imageView?.image = UIImage(named:"pause")
        if let artist = track.rArtist {
            trackLabel.text = "\(track.name) - \(artist.name)"
        } else {
            trackLabel.text = track.name
        }
        
        if let album = track.rAlbum,
            let imageCollection = album.rImage {
                if let data = imageCollection.dataSmall {
                    trackImage.image = UIImage(data: data)
                } else {
                    imageCollection.downloadImage(ImageCollection.ImageSize.Small, completionHandler: { (data:NSData) -> Void in
                        self.trackImage.image = UIImage(data: data)
                    })
                }
                
        }
    }
    func onTrackPaused(track:Track) {
        playButton.imageView?.image = UIImage(named:"play")
    }
    func onPlayFailed(track:Track, error:NSError?) {
        print(error)
    }
}
