//
//  UIHelper.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan on 2016-09-13.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class UIHelper: NSObject {
    static var rootViewController : UIViewController {
        get {
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            return (delegate!.window?.rootViewController)!
        }
    }
}
