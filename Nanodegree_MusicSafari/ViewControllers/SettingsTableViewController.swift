//
//  SettingsTableViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 9/7/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
struct Option {
    var text : String
    var selector : String
}

class SettingsTableViewController: UITableViewController {
    let config = [Option(text: "Logout", selector: "logout")]
    let cellIdentifier = "optionCell"
    var actionHandler : SettingsActionsHandler? = nil
    
    override func viewDidLoad() {
        actionHandler = SettingsActionsHandler(withController: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return config.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        cell?.textLabel!.text = config[indexPath.row].text
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let option = config[indexPath.row]
        actionHandler!.performSelector(Selector(option.selector))
    }
}

class SettingsActionsHandler : NSObject {
    
    private var viewController : UITableViewController
    
    init(withController: UITableViewController)
    {
        viewController = withController
    }
    
    func logout() {
        
        NSNotificationCenter.defaultCenter().postNotificationName("game_flow_logout", object: nil)
    }
}