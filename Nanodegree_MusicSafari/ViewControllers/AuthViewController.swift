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
    
    private var mainController : UIViewController?
    
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AuthViewController.onLogout(_:)), name: "game_flow_logout", object: nil)
        initAuth()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (loggedIn) {
            doLogin()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mainController = segue.destinationViewController
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
    
    func onLogout(notification:NSNotification) {
        let player = MusicPlayerFactory.defaultInstance
        statusLabel.text = "Logged out"
        player.logout()
        if let controller = mainController {
            loggedIn = false
            mainController = nil
            SPTAuthViewController.authenticationViewController().clearCookies(nil)
            controller.dismissViewControllerAnimated(true) { () -> Void in
            }
        }
        
    }
}

extension AuthViewController : SPTAuthViewDelegate {
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        statusLabel.text = "Login cancelled."
        loggedIn = false
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        statusLabel.text = "Login failed."
        loggedIn = false
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        statusLabel.text = "Login succeed!"
        loggedIn = true
        self.performSegueWithIdentifier("showMainScreen", sender: self)
        let player = MusicPlayerFactory.defaultInstance
        player.login()
        
        // init user core data stack
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.userStack = CoreDataStack(modelName: "UserModel", persistingDirectory: .DocumentDirectory, dbURLSuffix: "\(session.canonicalUsername)")
        }
    }
}
