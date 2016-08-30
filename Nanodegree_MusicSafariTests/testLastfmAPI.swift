//
//  testLastfmAPI.swift
//  Nanodegree_MusicSafari
//
//  Created by Xuan Yuan (Frank) on 8/17/16.
//  Copyright © 2016 frank-yuan. All rights reserved.
//
import Foundation
import XCTest
@testable import Nanodegree_MusicSafari

class testLastfmAPI: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchArtistAPI() {
        let semaphore = dispatch_semaphore_create(0);
        LastfmAPI.searchArtists("John"){ (result, error) in
            print("John")
            XCTAssertEqual(error, NetworkError.Succeed)
            let artists = AnyObjectHelper.parse(result, name: "results.artistmatches.artist")
            let result = artists as? NSArray
            XCTAssertGreaterThan(result!.count, 0)
            dispatch_semaphore_signal(semaphore);
        }
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, Int64(60 * NSEC_PER_SEC)));
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
