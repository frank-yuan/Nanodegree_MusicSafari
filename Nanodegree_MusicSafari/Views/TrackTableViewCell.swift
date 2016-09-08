//
//  TrackTableViewCell.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/30/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var playImage : UIImageView!
    @IBOutlet weak var likeButton : UIButton!
    
    var data : AnyObject?
    
    var name : String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var playEnabled : Bool = true {
        didSet {
            playImage.hidden = !playEnabled
        }
    }
    
    var playing : Bool = false {
        didSet {
            playImage.image = UIImage(named: playing ? "pause" : "play")
        }
    }
    
    var liked : Bool = false {
        didSet {
            likeButton.imageView!.image = UIImage(named: liked ? "liked" : "like")
        }
    }
    
    var likePressedCallback : ((TrackTableViewCell) -> Void)?
    
    @IBAction func onLikeButtonPressed () {
        if let callback = likePressedCallback {
            callback(self)
        }
    }
}
