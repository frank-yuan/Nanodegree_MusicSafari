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
    
    var authViewController : SPTAuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initAuth()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func onLoginClicked (sender: AnyObject) {
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
    }
}

extension AuthViewController : SPTAuthViewDelegate {
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        statusLabel.text = "Login cancelled."
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        statusLabel.text = "Login failed."
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        statusLabel.text = "Login succeed!"
        print(SPTAuth.defaultInstance().session.accessToken)
        dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("showMainScreen", sender: self)
    }
}
