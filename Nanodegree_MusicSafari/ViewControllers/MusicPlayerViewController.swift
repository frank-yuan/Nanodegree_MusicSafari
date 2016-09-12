//
//  TabBarPlayerViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/31/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class MusicPlayerViewController: UIViewController {
    // I do not know how to make reference like TabBarController
    // so I have to parse identifiers and instantiate view controllers when the view loaded
    // HOWTO: refer to child viewcontrollers like TabBarController on story board
    
    @IBOutlet weak var playerView : MusicPlayerView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let musicPlayer = MusicPlayerFactory.defaultInstance
        musicPlayer.registerDelegate(self)
        
        playerView.enabled = MusicPlayerFactory.defaultInstance.enabled
        if playerView.enabled {
            playerView.isPlaying = musicPlayer.isPlaying
            playerView.playingTrack = musicPlayer.currentTrack
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MusicPlayerFactory.defaultInstance.removeDelegate(self)
    }
    
    @IBAction func onPlayButtonTouched(sender:AnyObject?) {
        let musicPlayerInstance = MusicPlayerFactory.defaultInstance
        if (musicPlayerInstance.isPlaying) {
            musicPlayerInstance.pause()
        } else {
            musicPlayerInstance.resume()
        }
    }
}

extension MusicPlayerViewController : MusicPlayerDelegate {
    
    func didPlayerEnableChanged(enable:Bool) {
        playerView.enabled = enable
        
    }
    
    func onTrackPlayStarted(track:Track) {
        playerView.isPlaying = true
        playerView.playingTrack = track
    }
    
    func onPlayFailed(track:Track, error:NSError?) {
        print(error)
    }
    
    func onPlaybackStatusChanged(playing: Bool) {
        playerView.isPlaying = playing
    }
}
