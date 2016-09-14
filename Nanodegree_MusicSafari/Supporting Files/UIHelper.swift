//
//  UIHelper.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan on 2016-09-13.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class UIHelper: NSObject {
    static func getRootViewController(from viewController:UIViewController) -> UIViewController {
        var vc = viewController
        while vc.parentViewController != nil {
            vc = vc.parentViewController!
        }
        return vc
    }
}
