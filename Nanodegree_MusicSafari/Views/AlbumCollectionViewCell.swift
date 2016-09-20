//
//  AlbumView.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/22/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image : UIImageView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var artistName : UILabel?
    @IBOutlet weak var busyView : UIActivityIndicatorView!
    
    
    func setAlbum(album:Album, imageDownloadCompletionHandler:(()->Void)?) {
        name.text = album.name
        image.image = UIImage(named: "record")
        busyView.stopAnimating()
        busyView.hidden = true
        
        if artistName != nil {
            artistName!.text = album.rArtist?.name
        }
        
        if let imageCollection = album.rImage {
            if let imageData = imageCollection.dataMedium {
                image.image = UIImage(data: imageData)
                
            } else if imageCollection.urlLarge != nil{
                
                busyView.hidden = false
                busyView.startAnimating()
                
                imageCollection.downloadImage(.Medium) { (data:NSData?) -> Void in
                    self.busyView.stopAnimating()
                    imageDownloadCompletionHandler?()
                }
            }
        }
    }
}
