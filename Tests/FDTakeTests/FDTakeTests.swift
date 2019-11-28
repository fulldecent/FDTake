//
//  FDTakeTests.swift
//  FDTakeTests
//
//  Created by William Entriken on Sep 17, 2016.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import XCTest
@testable import FDTake

class FDTakeTests: XCTestCase {
    var fdTake: FDTakeController! = nil
    
    override func setUp() {
        super.setUp()
        fdTake = FDTakeController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocalization() {
        fdTake.cancelText = "bob"
        XCTAssertEqual(fdTake.cancelText, "bob")
        fdTake.chooseFromLibraryText = "bob"
        XCTAssertEqual(fdTake.chooseFromLibraryText, "bob")
        fdTake.chooseFromPhotoRollText = "bob"
        XCTAssertEqual(fdTake.chooseFromPhotoRollText, "bob")
        fdTake.noSourcesText = "bob"
        XCTAssertEqual(fdTake.noSourcesText, "bob")
        fdTake.takePhotoText = "bob"
        XCTAssertEqual(fdTake.takePhotoText, "bob")
        fdTake.takeVideoText = "bob"
        XCTAssertEqual(fdTake.takeVideoText, "bob")
    }
    
    func testOthersParams() {
        fdTake.allowsPhoto = false
        XCTAssertEqual(fdTake.allowsPhoto, false)
        
        fdTake.allowsVideo = false
        XCTAssertEqual(fdTake.allowsVideo, false)
        
        fdTake.allowsTake = false
        XCTAssertEqual(fdTake.allowsTake, false)
        
        fdTake.allowsSelectFromLibrary = false
        XCTAssertEqual(fdTake.allowsSelectFromLibrary, false)
        
        fdTake.allowsEditing = false
        XCTAssertEqual(fdTake.allowsEditing, false)
        
        fdTake.allowsSelectFromLibrary = false
        XCTAssertEqual(fdTake.allowsSelectFromLibrary, false)
        
        fdTake.iPadUsesFullScreenCamera = false
        XCTAssertEqual(fdTake.iPadUsesFullScreenCamera, false)
        
        fdTake.defaultsToFrontCamera = false
        XCTAssertEqual(fdTake.defaultsToFrontCamera, false)
        
        fdTake.defaultsToFrontCamera = false
        XCTAssertEqual(fdTake.defaultsToFrontCamera, false)
        
        fdTake.defaultsToFrontCamera = false
        XCTAssertEqual(fdTake.defaultsToFrontCamera, false)
        
        fdTake.presentingBarButtonItem = nil
        XCTAssertEqual(fdTake.presentingBarButtonItem, nil)
        
        fdTake.presentingView = nil
        XCTAssertEqual(fdTake.presentingView, nil)
        
        fdTake.presentingRect = nil
        XCTAssertEqual(fdTake.presentingRect, nil)
        
        fdTake.presentingTabBar = nil
        XCTAssertEqual(fdTake.presentingTabBar, nil)
    }
}
