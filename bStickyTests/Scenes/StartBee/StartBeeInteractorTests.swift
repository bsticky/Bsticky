//
//  StartBeeInteractorTest.swift
//  bStickyTests
//
//  Created by mima on 2021/07/28.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class StartBeeInteractorTest: XCTestCase {
    // MARK: Subject under test
    var sut: StartBeeInteractor!
        
    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupStartBeeInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    func setupStartBeeInteractor(){
        sut = StartBeeInteractor()
    }
        
    // MARK: Test doubles
    class StartBeePresentationLogicSpy: StartBeePresentationLogic{
        // Method call expectations
        var presentFetchedTagsCalled = false
        var presentStartCreateStickyCalled = false
        var presentStartListStickiesCalled = false
        var presentStartManageTagCalled = false
        
        // Spied methods
        func presentFetchedTags(response: StartBee.FetchTags.Response) {
            presentFetchedTagsCalled = true
        }
        
        func presentStartCreateSticky(response: StartBee.StartCreateSticky.Response) {
            presentStartCreateStickyCalled = true
        }
        
        func presentStartListStickies(response: StartBee.StartListStickies.Response) {
            presentStartListStickiesCalled = true
        }
        
        func presentStartManageTag(response: StartBee.StartManageTag.Response) {
            presentStartManageTagCalled = true
        }
    }
    
    class BeeWorkerSpy: BeeWorker {
        // Method call expectations
        var fetchTagsCalled = false
        
        // Spied methods
        override func fetchTags(compeletionHandler: @escaping ([Tag]) -> Void) {
            fetchTagsCalled = true
            compeletionHandler([Seeds.Tags.tagOne, Seeds.Tags.tagTwo])
        }
    }
    
    // MARK: - Tests
    
    func testFetchTagsShouldAskBeeWorkerToFetchTagsAndPresenterToFormatResult() {
        // Given
        let startBeePresentationLogicSpy = StartBeePresentationLogicSpy()
        sut.presenter = startBeePresentationLogicSpy
        let beeWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = beeWorkerSpy
        
        // When
        let request = StartBee.FetchTags.Request()
        sut.fetchTags(request: request)
        
        // Then
        XCTAssertTrue(beeWorkerSpy.fetchTagsCalled, "FetchTags() should ask BeeWorker to fetch tags")
        XCTAssert(startBeePresentationLogicSpy.presentFetchedTagsCalled, "FetchTags() should ask presenter to format tags result")
    }
    
    func testStartManageTagShouldAskPresenterToFormatResult(){
        // Given
        let startBeePresentationLogicSpy = StartBeePresentationLogicSpy()
        sut.presenter = startBeePresentationLogicSpy
        
        // When
        let request = StartBee.StartManageTag.Request(tagId: 1, tagButtonPosition: 1)
        sut.startManageTag(request: request)
        
        // Then
        XCTAssert(startBeePresentationLogicSpy.presentStartManageTagCalled, "startManageTag() should ask presenter to format tag result")
    }
    
    func testStartCreateStickyShouldAskPresenterToFormatResult() {
        // Given
        let startBeePresentationLogicSpy = StartBeePresentationLogicSpy()
        sut.presenter = startBeePresentationLogicSpy
        
        // When
        let request = StartBee.StartCreateSticky.Request(tagId: 1, tagColor: "#FFFFFF")
        sut.startCreateSticky(request: request)
        
        // Then
        XCTAssert(startBeePresentationLogicSpy.presentStartCreateStickyCalled, "startCreateSticky() should ask presenter to presentStartCreateSticky")
    }
    
    func testStartListStickiesShouldAskPresenterToFormatResult() {
        // Given
        let startBeePresentationLogicSpy = StartBeePresentationLogicSpy()
        sut.presenter = startBeePresentationLogicSpy
        
        // When
        let request = StartBee.StartListStickies.Request(tagId: 1, tagName: "TagOne", tagColor: "#FFFFFF")
        sut.startListStickies(request: request)
        
        // Then
        XCTAssert(startBeePresentationLogicSpy.presentStartListStickiesCalled, "startListsStickies() should ask presenter to presentStartListStickies")
    }
}
