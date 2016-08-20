//
//  Constants.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Constants

struct Constants {
    
    // MARK: last.fm
    struct Lastfm {
        static let APIScheme = "https"
        static let APIHost = "ws.audioscrobbler.com"
        static let APIPath = "/2.0/"
    }
    
    struct LastfmParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Format = "format"
        static let Page = "page"
        static let Limit = "limit"
    }
    
    struct LastfmParameterArtist {
        static let Artist = "artist"
        static let Search = "artist.search"
        static let ResultKey = "results.artistmatches.artist"
    }
    
    struct LastfmParameterValues {
        static let APIKey = "212b2d18bb908061a3f0d5281f2fd561"
        static let ResponseFormat = "json"
    }
    
    struct LastfmResponseKeys {
        static let ID = "mbid"
        static let Name = "name"
        static let Image = "image"
        static let Size = "size"
        static let URLText = "#text"
    }
    
    struct LastfmResponseValues {
        static let Medium = "medium"
        static let Large = "large"
    }

    
    static let JSONPathDelimiter = NSCharacterSet(charactersInString: ".")
//    // MARK: Flickr
//    struct Flickr {
//        static let APIScheme = "https"
//        static let APIHost = "api.flickr.com"
//        static let APIPath = "/services/rest"
//        
//        static let SearchBBoxHalfWidth = 1.0
//        static let SearchBBoxHalfHeight = 1.0
//        static let SearchLatRange = (-90.0, 90.0)
//        static let SearchLonRange = (-180.0, 180.0)
//        static let MaxDisplayableImageCount = 4000
//    }
//    
//    // MARK: Flickr Parameter Keys
//    struct FlickrParameterKeys {
//        static let Method = "method"
//        static let APIKey = "api_key"
//        static let GalleryID = "gallery_id"
//        static let Extras = "extras"
//        static let Format = "format"
//        static let NoJSONCallback = "nojsoncallback"
//        static let SafeSearch = "safe_search"
//        static let Text = "text"
//        static let BoundingBox = "bbox"
//        static let Page = "page"
//        static let PerPage = "per_page"
//    }
//    
//    // MARK: Flickr Parameter Values
//    struct FlickrParameterValues {
//        static let SearchMethod = "flickr.photos.search"
//        static let APIKey = "90aed9a571d69ed8b58eb369c7b37dfc"
//        static let ResponseFormat = "json"
//        static let DisableJSONCallback = "1" /* 1 means "yes" */
//        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
//        static let GalleryID = "5704-72157622566655097"
//        static let MediumURL = "url_m"
//        static let UseSafeSearch = "1"
//        static let RecordPerPage = 21
//    }
//    
//    // MARK: Flickr Response Keys
//    struct FlickrResponseKeys {
//        static let ID = "id"
//        static let Status = "stat"
//        static let Photos = "photos"
//        static let Photo = "photo"
//        static let Title = "title"
//        static let MediumURL = "url_m"
//        static let Page = "page"
//        static let Pages = "pages"
//        static let Total = "total"
//    }
//    
//    // MARK: Flickr Response Values
//    struct FlickrResponseValues {
//        static let OKStatus = "ok"
//    }
//    
//    struct EntityName{
//        static let MapCoordinate = "MapCoordinate"
//        static let FlickrPhoto = "FlickrPhoto"
//    }
//    
//    struct UI {
//        struct CollectionViewBackgroundColor{
//            static let normal = UIColor(red: 0.3922, green: 0.6471, blue: 0.7608, alpha: 1)
//            static let highlighted = UIColor.redColor()
//        }
//    }
    
}