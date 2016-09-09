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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.enabled = MusicPlayerFactory.defaultInstance.enabled
    }
    
    override func viewWillAppear(animated: Bool) {
        MusicPlayerFactory.defaultInstance.registerDelegate(playerView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        MusicPlayerFactory.defaultInstance.removeDelegate(playerView)
    }
}
