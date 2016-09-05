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
    //@IBOutlet weak var similarArtistsCollection : UICollectionView!
    @IBOutlet weak var summaryLabel:UILabel!
    let cellSpacing:CGFloat = 10.0
    
    private var contentCommandQueue = [ContentChangeCommand]()
    
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            
            fetchedResultsController?.delegate = self
            executeSearch()
            albumsCollection.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        resizeCollectionLayout()
        let id = artist!.id!
        
        let fr = NSFetchRequest(entityName: String(Album.self))
        fr.predicate = NSPredicate(format: "rArtist = %@", argumentArray: [artist!])
        fr.sortDescriptors = [NSSortDescriptor(key:"id", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: CoreDataHelper.getLibraryStack().context, sectionNameKeyPath: nil, cacheName: nil)
        
        let workerContext = fetchedResultsController?.managedObjectContext
        AlbumAPI.getArtistTopAlbums(id, context: workerContext!){ result -> Void in
            performUIUpdatesOnMain({ 
                self.executeSearch()
                self.albumsCollection.reloadData()
            })
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func resizeCollectionLayout() {
        let count:CGFloat = albumsCollection.frame.width > albumsCollection.frame.height ? 5.0 : 3.0
        let size:CGFloat = (albumsCollection.frame.width - (count + 1) * cellSpacing) / count
        albumsLayout.itemSize = CGSize(width: size, height: size + 20)
    }
    
}

extension ArtistDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as? AlbumCollectionViewCell
        if let album = fetchedResultsController?.objectAtIndexPath(indexPath) as? Album {
            cell?.setAlbum(album)
        }
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("AlbumDetailViewController") as! AlbumDetailViewController
        vc.album = fetchedResultsController?.objectAtIndexPath(indexPath) as? Album
        navigationController?.pushViewController(vc, animated: true)
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
