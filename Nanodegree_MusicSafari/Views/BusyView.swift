//
//  BusyView.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/21/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class BusyView: UIView {
    var activityView : UIActivityIndicatorView?
    convenience init(parent:UIView) {
        self.init(frame: parent.frame)
        self.backgroundColor = UIColor.darkGrayColor()
        self.alpha = 0.3
        activityView = UIActivityIndicatorView(frame: parent.frame)
        activityView?.startAnimating()
        activityView?.center = self.center
        self.addSubview(activityView!)
        self.autoresizingMask = parent.autoresizingMask
    }
    
}
