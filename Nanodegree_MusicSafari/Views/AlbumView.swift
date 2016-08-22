//
//  AlbumView.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/22/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    @IBOutlet weak var image : UIImageView!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var artistName : UILabel!
    
    func setAlbum(album:Album) {
        if let imageData = album.imageMedium {
            image.image = UIImage(data: imageData)
        }
        name.text = album.name
        artistName.text = album.rArtist?.name
    }
    /*        
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
