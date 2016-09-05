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
    @IBOutlet weak var playButton : UIButton!
    private var playing : Bool = false
    private var _track : Track?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func onPlayButtonClicked() {
        playing = !playing
        updatePlayButton()
        
        if (playing) {
            MusicPlayerFactory.defaultInstance.playTrack(_track)
        } else {
            MusicPlayerFactory.defaultInstance.pause()
        }
    }
    
    func setTrack(track:Track?) {
        if let track = track {
            _track = track
            nameLabel.text = track.name
            stopPlaying()
            playButton.enabled = MusicPlayerFactory.defaultInstance.enabled
        }
    }
    
    func stopPlaying() {
        playing = false
        updatePlayButton()
    }
    
    func updatePlayButton() {
        
        if (playing) {
            playButton.setImage(UIImage(named: "pause"), forState: .Normal)
            playButton.setImage(UIImage(named: "pause"), forState: .Highlighted)
        } else {
            playButton.setImage(UIImage(named: "play"), forState: .Normal)
            playButton.setImage(UIImage(named: "play"), forState: .Highlighted)
            
        }
    }
}
