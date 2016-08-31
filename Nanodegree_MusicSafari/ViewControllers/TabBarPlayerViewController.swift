//
//  TabBarPlayerViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/31/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class TabBarPlayerViewController: UIViewController {
    // I do not know how to make reference like TabBarController
    // so I have to parse identifiers and instantiate view controllers when the view loaded
    // TODO: use reference instead of string
    @IBInspectable var controllerIdentifiers : String?
    @IBInspectable var initialIndex : Int = 0
    @IBOutlet weak var container : UIView!
    @IBOutlet weak var tabBar : UITabBar!
    
    private var _viewControllers = [UIViewController?]()
    private var _currentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.frame.size = view.frame.size
        
        if let controllerId = controllerIdentifiers {
            let identifiers = controllerId.componentsSeparatedByString(",")
            for identifier in identifiers {
                _viewControllers.append(storyboard?.instantiateViewControllerWithIdentifier(identifier))
            }
        }
        
        tabBar.selectedItem = tabBar.items![initialIndex]
        showViewWithIndex(initialIndex)
        
    }
    
    func showViewWithIndex(index:Int) {
        
        if (index != _currentIndex) {
            
            _currentIndex = index
            
            for view in container.subviews {
                view.removeFromSuperview()
            }
            
            let view = _viewControllers[index]!.view
            view.frame.size = container.frame.size
            view.layoutIfNeeded()
            
            container.addSubview(view)
        }
        self.view.layoutIfNeeded()
        
    }
}

extension TabBarPlayerViewController : UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let index = tabBar.items?.indexOf(item) {
            showViewWithIndex(index)
        }
    }
}