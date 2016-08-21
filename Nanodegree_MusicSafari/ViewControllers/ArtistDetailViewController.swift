//
//  FirstViewController.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit
import CoreData

class ArtistDetailViewController: UIViewController {

    var artist : Artist?
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var portrait:UIImageView!
    @IBOutlet weak var albumsCollection : UICollectionView!
    //@IBOutlet weak var similarArtistsCollection : UICollectionView!
    @IBOutlet weak var summaryLabel:UILabel!
    
    
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

