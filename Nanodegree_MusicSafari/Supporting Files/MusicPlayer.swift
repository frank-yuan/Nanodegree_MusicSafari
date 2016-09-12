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
    optional func onPlayFailed(track:Track, error:NSError?)
    optional func onPlaybackStatusChanged(playing:Bool)
}

protocol MusicPlayerInterface {
    
    func login()
    
    func logout()
    
    func registerDelegate(delegate : MusicPlayerDelegate)
    
    func removeDelegate(delegate : MusicPlayerDelegate)
    
    func playTrack(track:Track?)
    
    func pause()
    
    func resume()
    
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
            return streamController.loggedIn
                && streamController.playbackState != nil
                && streamController.playbackState.isPlaying
        }
    }
    
    func login() {
        do {
            streamController = SPTAudioStreamingController.sharedInstance()
            if !streamController.initialized {
                try streamController.startWithClientId(Constants.SpotifyAuth.ClientID)
            }
            streamController.delegate = self
            streamController.playbackDelegate = self
            streamController.diskCache = SPTDiskCache(capacity: 1024*1024*64)
            streamController.loginWithAccessToken(SPTAuth.defaultInstance().session.accessToken)
        } catch{
            print("Error init streamController")
        }
    }
    
    func logout() {
        streamController = SPTAudioStreamingController.sharedInstance()
        streamController.logout()
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
            streamController.setIsPlaying(false) { (error) -> Void in
                guard error == nil else {
                    print("playback stop error")
                    return
                }
                
            }
        }
    }
    
    func resume() {
        if streamController.loggedIn {
            streamController.setIsPlaying(true) { (error) -> Void in
                guard error == nil else {
                    print("playback stop error")
                    return
                }
                
            }
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
        let streamController = SPTAudioStreamingController.sharedInstance()
        do {
            try streamController.stop()
        } catch {
            print("Error in stop audio stream")
        }
        
        performUIUpdatesOnMain({ () -> Void in
            for del in self.delegates {
                if let callback = del.didPlayerEnableChanged {
                    callback(false)
                }
            }
        })
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
    
    func audioStreamingdidLogout(audioStreaming : SPTAudioStreamingController) {
        
    }
}
