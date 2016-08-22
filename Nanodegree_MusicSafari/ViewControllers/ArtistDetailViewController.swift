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
    
    var fetchedResultController : NSFetchedResultsController? {
        didSet {
            
            fetchedResultController?.delegate = self
            do{
                try fetchedResultController!.performFetch()
            }catch let e as NSError{
                print("Error while trying to perform a search: \n\(e)\n")
            }
            albumsCollection.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = artist?.name
        if let imageData = artist?.imageMedium {
            portrait.image = UIImage(data:imageData)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }

}

extension ArtistDetailViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (fetchedResultController?.fetchedObjects?.count)!
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath)
        if let albumView =  NSBundle.mainBundle().loadNibNamed("AlbumView", owner: self, options: nil).first as? AlbumView {
            cell.contentView.addSubview(albumView)
            albumView.setAlbum(fetchedResultController?.objectAtIndexPath(indexPath) as! Album)
            albumView.autoresizingMask = cell.contentView.autoresizingMask
        }
        return cell
    }
}

extension ArtistDetailViewController : NSFetchedResultsControllerDelegate {
    
}
