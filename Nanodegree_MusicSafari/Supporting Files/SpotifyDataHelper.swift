//
//  SpotifyDataHelper.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/25/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//


class SpotifyDataHelper: NSObject {
    static func parseImageArray(data:NSArray?) -> [SPTImage] {
        var result = [SPTImage]()
        if let data = data {
            for item in data {
                do {
                    result.append(try SPTImage(fromDecodedJSON: item))
                } catch {
                }
                result.sortInPlace({ (left, right) -> Bool in
                    return left.size.width < right.size.width
                })
            }
        }
        return result
    }
}
