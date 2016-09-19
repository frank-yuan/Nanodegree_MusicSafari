//
//  FirstViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData

class ArtistDetailViewController: UIViewController{
    
    var artist : Artist?
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var portrait:UIImageView!
    @IBOutlet weak var albumsCollection : UICollectionView!
    @IBOutlet weak var albumsLayout : UICollectionViewFlowLayout!
    let cellSpacing:CGFloat = 1.0
    
    private var contentCommandQueue = [ContentChangeCommand]()
    
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            
            executeSearch()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController?.delegate = self
        
        navigationItem.title = artist?.name
        nameLabel.text = artist?.name
        
        if let imageCollection = artist?.rImage {
            
            if let imageData = imageCollection.dataLarge{
                portrait.image = UIImage(data:imageData)
            } else {
                imageCollection.downloadImage(.Large) { (data:NSData) -> Void in
                    performUIUpdatesOnMain({ 
                        self.portrait.image = UIImage(data:data)
                    })
                }
            }
            
        }
        
        albumsCollection.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeCollectionLayout()
    }
    
    func resizeCollectionLayout() {
        let count:CGFloat = 3.0
        let size:CGFloat = (albumsCollection.frame.width - (count + 1) * cellSpacing) / count
        albumsLayout.itemSize = CGSize(width: size, height: size + 20)
        albumsLayout.minimumInteritemSpacing = cellSpacing
        albumsLayout.minimumLineSpacing = cellSpacing
    }
    
}

extension ArtistDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCollectionViewCell
        if let album = fetchedResultsController?.objectAtIndexPath(indexPath) as? Album {
            cell?.setAlbum(album) { [weak self] in
                performUIUpdatesOnMain({ [weak self] in
                    self?.albumsCollection.reloadData()
                })
            }
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AlbumDetailViewController") as! AlbumDetailViewController
        if let album = fetchedResultsController?.objectAtIndexPath(indexPath) as? Album {
            vc.album = album
            let id = album.id!
            
            let fr = NSFetchRequest(entityName: String(Track.self))
            fr.predicate = NSPredicate(format: "rAlbum == %@", argumentArray: [album])
            fr.sortDescriptors = [NSSortDescriptor(key:"discNum", ascending: true), NSSortDescriptor(key:"trackNum", ascending: true)]
            vc.fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
            
            if vc.fetchedResultsController?.fetchedObjects?.count == 0 {
                
                let rootView = UIHelper.getRootViewController(from:self).view
                let busyView = BusyView(parent: rootView!)
                rootView!.addSubview(busyView)
                
                let workerContext = vc.fetchedResultsController?.managedObjectContext
                TrackAPI.getTracksByAlbum(id, context: workerContext!){ error, result -> Void in
                    performUIUpdatesOnMain({
                        busyView.removeFromSuperview()
                        guard error == .Succeed else {
                            HttpServiceHelper.showErrorAlert(error, forViewController: self)
                            return
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                }
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
                let workerContext = vc.fetchedResultsController?.managedObjectContext
                TrackAPI.getTracksByAlbum(id, context: workerContext!, completionHandler: nil)
                
            }
        }
    }
}

extension ArtistDetailViewController {
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
}

extension ArtistDetailViewController : NSFetchedResultsControllerDelegate {
    
    struct ContentChangeCommand {
        let type : NSFetchedResultsChangeType
        let indexPath : NSIndexPath?
        let newIndexPath : NSIndexPath?
    }
    
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            
        case .Insert:
            albumsCollection.insertSections(set)
            
        case .Delete:
            albumsCollection.deleteSections(set)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
        
        contentCommandQueue.append(ContentChangeCommand(type: type, indexPath: indexPath, newIndexPath: newIndexPath))
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        albumsCollection.performBatchUpdates({
            for command in self.contentCommandQueue {
                
                
                switch(command.type){
                    
                case .Insert:
                    self.albumsCollection.insertItemsAtIndexPaths([command.newIndexPath!])
                    
                case .Delete:
                    self.albumsCollection.deleteItemsAtIndexPaths([command.indexPath!])
                    
                case .Update:
                    self.albumsCollection.reloadItemsAtIndexPaths([command.indexPath!])
                    
                case .Move:
                    self.albumsCollection.deleteItemsAtIndexPaths([command.indexPath!])
                    self.albumsCollection.insertItemsAtIndexPaths([command.newIndexPath!])
                }
            }
            }, completion: nil)
        contentCommandQueue.removeAll()
        albumsCollection.reloadData()
    }
}
