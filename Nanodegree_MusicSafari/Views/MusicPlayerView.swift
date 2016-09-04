//
//  MusicPlayerView.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/4/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class MusicPlayerView: UIView {

    @IBOutlet weak var playButton : UIButton!
    @IBOutlet weak var forwardButton : UIButton!
    @IBOutlet weak var backwardButton : UIButton!
    @IBOutlet weak var trackImage : UIImageView!
    @IBOutlet weak var trackLabel : UILabel!
    
    var enabled : Bool = false{
        didSet{
            playButton.enabled = enabled
            forwardButton.enabled = enabled
            backwardButton.enabled = enabled
            trackLabel.enabled = enabled
        }
    }
}
