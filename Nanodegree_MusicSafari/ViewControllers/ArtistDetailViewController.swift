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
    //@IBOutlet weak var similarArtistsCollection : UICollectionView!
    @IBOutlet weak var summaryLabel:UILabel!
    
    private var contentCommandQueue = [ContentChangeCommand]()
    
    var fetchedResultController : NSFetchedResultsController? {
        didSet {
            
            fetchedResultController?.delegate = self
            executeSearch()
            albumsCollection.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = artist?.name
        if let imageData = artist?.imageLarge {
            portrait.image = UIImage(data:imageData)
        }
        
        let id = artist!.id!
        CoreDataHelper.getLibraryStack().performBackgroundBatchOperation { (workerContext) in
            ArtistManager.getArtistTopAlbums(id, context: workerContext, completionHandler: nil)
        }
        let fr = NSFetchRequest(entityName: String(Album.self))
        fr.predicate = NSPredicate(format: "rArtist = %@", argumentArray: [artist!])
        fr.sortDescriptors = [NSSortDescriptor(key:"id", ascending: true)]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
    }

}

extension ArtistDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultController?.fetchedObjects?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath)
        if let albumView =  NSBundle.mainBundle().loadNibNamed("AlbumView", owner: self, options: nil).first as? AlbumView {
            cell.contentView.addSubview(albumView)
            albumView.setAlbum(fetchedResultController?.objectAtIndexPath(indexPath) as! Album)
            albumView.autoresizingMask = cell.contentView.autoresizingMask
        }
        return cell
    }
}
extension ArtistDetailViewController {
    
    func executeSearch(){
        if let fc = fetchedResultController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultController)")
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
