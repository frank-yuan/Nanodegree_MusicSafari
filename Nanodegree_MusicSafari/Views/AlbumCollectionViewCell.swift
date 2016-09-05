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
    
    func setAlbum(album:Album) {
        if let imageCollection = album.rImage {
            if let imageData = imageCollection.dataMedium {
                image.image = UIImage(data: imageData)
            } else if imageCollection.urlLarge != nil{
                imageCollection.downloadImage(.Medium) { (data:NSData) -> Void in
                    self.image.image = UIImage(data: data)
                }
            }
        }
        name.text = album.name
        
        if artistName != nil {
            artistName!.text = album.rArtist?.name
        }
    }
    

}
