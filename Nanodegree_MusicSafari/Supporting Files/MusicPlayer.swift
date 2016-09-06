//
//  MusicPlayer.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/1/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//


@objc protocol MusicPlayerDelegate {
    optional func didPlayerEnableChanged(enable:Bool)
    optional func onTrackPlayStarted(track:Track)
    optional func onTrackPaused(track:Track)
    optional func onPlayFailed(track:Track, error:NSError?)
    optional func onPlaybackStatusChanged(playing:Bool)
}

protocol MusicPlayerInterface {
    
    func login()
    
    func registerDelegate(delegate : MusicPlayerDelegate)
    
    func removeDelegate(delegate : MusicPlayerDelegate)
    
    func playTrack(track:Track?)
    
    func pause()
    
    var currentTrack : Track? {get}
    
    var enabled : Bool {get}
    
    var isPlaying : Bool {get}
    
}

class MusicPlayerFactory : NSObject {
    
    static var defaultInstance : MusicPlayerInterface {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MusicPlayerInterface? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = SpotifyMusicPlayer()
        }
        return Static.instance!
    }
}

class SpotifyMusicPlayer: NSObject{
    
    private var streamController = SPTAudioStreamingController.sharedInstance()
    
    private var delegates  = NSMutableSet()
    
    var currentTrack : Track? = nil
}

extension SpotifyMusicPlayer : MusicPlayerInterface {
    
    var enabled : Bool {
        get {
            return streamController.loggedIn
        }
    }
    
    var isPlaying : Bool {
        get {
            return streamController.playbackState.isPlaying
        }
    }
    
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
    
    func playTrack(track:Track?) {
        if streamController.loggedIn {
            
            if let track = track {
                
                if let state = streamController.playbackState where state.isPlaying{
                    streamController.setIsPlaying(false, callback: { (error) -> Void in
                        guard error == nil else {
                            print("playback stop error")
                            return
                        }
                        
                    })
                }
                
                streamController.playSpotifyURI(track.uri, startingWithIndex: 0, startingWithPosition: NSTimeInterval(0)) { (error) -> Void in
                    guard error == nil else {
                        print("Playback error: \(error)")
                        return
                    }
                    
                    self.currentTrack = track
                    
                    performUIUpdatesOnMain({ () -> Void in
                        for del in self.delegates {
                            if let callback = del.onTrackPlayStarted {
                                callback(self.currentTrack!)
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    func pause() {
        if streamController.loggedIn {
            streamController.setIsPlaying(false, callback: { (error) -> Void in
                guard error == nil else {
                    print("playback stop error")
                    return
                }
                performUIUpdatesOnMain({ () -> Void in
                    for del in self.delegates {
                        if let callback = del.onTrackPaused {
                            callback(self.currentTrack!)
                        }
                    }
                })
            })
            
        }
    }
    

}

extension SpotifyMusicPlayer : SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
        performUIUpdatesOnMain({ () -> Void in
            for del in self.delegates {
                if let callback = del.didPlayerEnableChanged {
                    callback(true)
                }
            }
        })
    }
    
    func audioStreamingDidLogout(audioStreaming: SPTAudioStreamingController!) {
        performUIUpdatesOnMain({ () -> Void in
            for del in self.delegates {
                if let callback = del.didPlayerEnableChanged {
                    callback(false)
                }
            }
        })
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didEncounterError error: NSError!) {
        print(error)
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        print(message)
    }
    
    func audioStreamingDidDisconnect(audioStreaming: SPTAudioStreamingController!) {
        performUIUpdatesOnMain({ () -> Void in
            for del in self.delegates {
                if let callback = del.didPlayerEnableChanged {
                    callback(false)
                }
            }
        })
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        performUIUpdatesOnMain({ () -> Void in
            for del in self.delegates {
                if let callback = del.onPlaybackStatusChanged {
                    callback(isPlaying)
                }
            }
        })
    }
}
