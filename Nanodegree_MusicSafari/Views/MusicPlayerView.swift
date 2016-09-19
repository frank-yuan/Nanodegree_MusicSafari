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
    @IBOutlet weak var volumeSlider : UISlider!
    
    var volumeActionHandler : ((Float)->Void)?
    
    var enabled : Bool = false{
        didSet{
            playButton.enabled = enabled
            trackLabel.enabled = enabled
            volumeSlider.enabled = enabled
        }
    }
    
    weak var playingTrack : Track? = nil {
        didSet {
            trackLabel.text = ""
            trackImage.image = UIImage(named: "record")
            if let track = playingTrack {
                
                trackLabel.text = track.name!
                
                if let album = track.rAlbum{
                    if let artist = album.rArtist,
                        artistName = artist.name{
                            trackLabel.text = "\(track.name!) - \(artistName)"
                    }
                    if let imageCollection = album.rImage {
                        if let data = imageCollection.dataSmall {
                            trackImage.image = UIImage(data: data)
                        } else {
                            imageCollection.downloadImage(ImageCollection.ImageSize.Small, completionHandler: { (data:NSData?) -> Void in
                                if let data = data {
                                    self.trackImage.image = UIImage(data: data)
                                }
                            })
                        }
                        
                    }
                }
            }
        }
    }
    
    var isPlaying : Bool = false {
        didSet{
            playButton.imageView?.image = UIImage(named:isPlaying ? "pause" : "play")
        }
    }
    
    var volume : Float = 0{
        didSet {
            volumeSlider.value = volume
        }
    }
    
    @IBAction func onVolumeValueChanged(sender:UISlider) {
        self.volumeActionHandler?(sender.value)
    }
}
