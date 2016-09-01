//
//  AuthViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/23/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var loginButton : UIButton!
    @IBOutlet weak var statusLabel : UILabel!
    
    
    private var loggedIn : Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(Constants.SpotifyLoggedInPrefKey)
        }
        set(value) {
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: Constants.SpotifyLoggedInPrefKey)
        }
    }
    
    var authViewController : SPTAuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAuth()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (loggedIn) {
            doLogin()
        }
    }

    
    @IBAction func onLoginClicked (sender: AnyObject) {
        doLogin()
    }
    
    @IBAction func onClearClicked (sender: AnyObject) {
        authViewController = SPTAuthViewController.authenticationViewController()
        authViewController?.clearCookies(nil)
        loggedIn = false
    }
    
    func doLogin() {
        statusLabel.text = "Logging in ..."
        authViewController = SPTAuthViewController.authenticationViewController()
        authViewController?.delegate = self
        authViewController?.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.presentViewController(authViewController!, animated: false, completion: nil)
    }
    
    func initAuth() {
        let auth = SPTAuth.defaultInstance()
        auth.clientID = Constants.SpotifyAuth.ClientID
        auth.requestedScopes = [SPTAuthStreamingScope]
        auth.redirectURL = NSURL(string: Constants.SpotifyAuth.AuthCallback)
        auth.sessionUserDefaultsKey = Constants.SpotifyAuth.SessionDefaultKey
        auth.requestedScopes = [SPTAuthStreamingScope]
    }
}

extension AuthViewController : SPTAuthViewDelegate {
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        statusLabel.text = "Login cancelled."
        loggedIn = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        statusLabel.text = "Login failed."
        loggedIn = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        statusLabel.text = "Login succeed!"
        let player = SpotifyMusicPlayer.defaultInstance
        player.login()
        loggedIn = true
        print(SPTAuth.defaultInstance().session.accessToken)
        dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("showMainScreen", sender: self)
    }
}
