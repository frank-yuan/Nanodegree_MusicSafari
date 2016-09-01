//
//  MusicPlayer.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/1/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//


@objc protocol MusicPlayerDelegate {
    optional func onTrackPlaying(track:Track)
    optional func onTrackStopped(track:Track)
    optional func onPlayFailed(track:Track, error:NSError?)
}

protocol MusicPlayerInterface {
    func login()
    
    func registerDelegate(delegate : MusicPlayerDelegate)
    
    func removeDelegate(delegate : MusicPlayerDelegate)
    
    func playPlayList(tracks:[Track], startFrom index:Int)
    
    func playPlayListFromFirst(tracks:[Track])
    
    func stop()
    
    func playNext()
        
    func playPrevious()
    
    func currentTrack() -> Track?
}

class SpotifyMusicPlayer: NSObject, MusicPlayerInterface {
    
    
    static var defaultInstance : MusicPlayerInterface {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: SpotifyMusicPlayer? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SpotifyMusicPlayer()
        }
        return Static.instance!
    }
    
    private var streamController = SPTAudioStreamingController.sharedInstance()
    
//    private var audioController = SPTCoreAudioController()
    
    private var delegates  = NSMutableSet()
    
    
    func login() {
        do {
            streamController = SPTAudioStreamingController.sharedInstance()
            try streamController.startWithClientId(Constants.SpotifyAuth.ClientID)
            streamController.delegate = self
            streamController.playbackDelegate = self
            streamController.diskCache = SPTDiskCache(capacity: 1024*1024*64)
            streamController.loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
        } catch{
            print("Error init streamController")
        }
    }
    
    func registerDelegate(delegate : MusicPlayerDelegate) {
        delegates.addObject(delegate)
    }
    
    func removeDelegate(delegate : MusicPlayerDelegate) {
        delegates.removeObject(delegate)
    }
    
    func playPlayListFromFirst(tracks: [Track]) {
        playPlayList(tracks, startFrom: 0)
    }
    
    func playPlayList(tracks:[Track], startFrom index:Int) {
        if streamController.loggedIn {
            
            if let state = streamController.playbackState where state.isPlaying{
                streamController.setIsPlaying(false, callback: { (error) -> Void in
                    guard error == nil else {
                        print("playback stop error")
                        return
                    }
                })
            }
            
            streamController.playSpotifyURI(tracks[0].uri, startingWithIndex: 0, startingWithPosition: NSTimeInterval(0)) { (error) -> Void in
                guard error == nil else {
                    print("Playback error: \(error)")
                    return
                }
            }
        }
        
    }
    
    func stop() {
        if streamController.loggedIn {
            streamController.setIsPlaying(false, callback: { (error) -> Void in
                guard error == nil else {
                    print("playback stop error")
                    return
                }
            })
            
        }
    }
    
    func playNext() {
        
    }
    
    func playPrevious() {
        
    }
    
    func currentTrack() -> Track? {
        return nil
    }

}

extension SpotifyMusicPlayer : SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
    }
    
    func audioStreamingDidLogout(audioStreaming: SPTAudioStreamingController!) {
        print("log out")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didEncounterError error: NSError!) {
        print(error)
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        print(message)
    }
    
    func audioStreamingDidDisconnect(audioStreaming: SPTAudioStreamingController!) {
        print ("disconnect")
    }

}
