//
//  AnyObjectHelper.swift
//  Nanodegree_OnTheMap
//
//  Created by Xuan Yuan (Frank) on 8/2/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AnyObjectHelper{
    static func parse(object:AnyObject?, name:String) -> AnyObject? {
        var node = object
        let keys = name.componentsSeparatedByCharactersInSet(Constants.JSONPathDelimiter)
        for key in keys {
            if node == nil {
                break;
            }
            node = node![key]
        }
        return node
    }
    
    static func parseWithDefault<T>(object:AnyObject?, name:String, defaultValue:T) -> T {
        if let result = parse(object, name: name) as? T {
            return result
        }
        return defaultValue
    }
}

class AutoSelectorCaller : NSObject{
    
    private let sender: AnyObject
    private let releaseSelector : Selector
    
    init(sender: AnyObject, releaseSelector: Selector) {
        self.sender = sender
        self.releaseSelector = releaseSelector
    }
    
    init(sender: AnyObject, startSelector: Selector, releaseSelector: Selector) {
        self.sender = sender
        self.releaseSelector = releaseSelector
        sender.performSelectorOnMainThread(startSelector, withObject: nil, waitUntilDone: false)
    }
    
    deinit {
        sender.performSelectorOnMainThread(releaseSelector, withObject: nil, waitUntilDone: false)
    }
}


extension UIViewController {

    func showAlert(title: String, buttonText: String = "OK",  message: String = "", completionHandler: (()->Void)? = nil ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: completionHandler)
    }
}


class CoreDataHelper : NSObject {
    
    static func getLibraryStack() -> CoreDataStack {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.libraryStack
    }
    
    static func getUserStack() -> CoreDataStack {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.userStack
    }
    
    static func syncCoreData(entityName:String, indexNameOfManagedObject:String, responseArray:NSArray, indexNameOfResponse:String, context:NSManagedObjectContext, completionHandler:(([String : AnyObject?])->Void)?) {
        
        var keys = [String]()
        for item in responseArray {
            let key = AnyObjectHelper.parseWithDefault(item, name: indexNameOfResponse, defaultValue: "")
            if key.characters.count > 0{
                keys.append(key)
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: String(Artist.self))
        fetchRequest.predicate = NSPredicate(format: "\(indexNameOfManagedObject) IN %@", argumentArray: [keys])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: indexNameOfManagedObject, ascending: true)]
        
        let manageredObject = try! context.executeFetchRequest(fetchRequest)
        var dic = [String : AnyObject?]()
        
        for obj in manageredObject  {
            if let artist = obj as? Artist {
                dic[artist.id!] = artist
            }
        }
        
        for item in responseArray {
            let key = AnyObjectHelper.parseWithDefault(item, name: indexNameOfResponse, defaultValue: "")
            if key.characters.count > 0{
                if let artist = dic[key] as? Artist {
                    artist.update(item)
                } else {
                    dic[key] = Artist(dictionary: item, context: context)
                }
            }
        }
        
        if let completionHandler = completionHandler{
            completionHandler(dic)
        }
    }
}