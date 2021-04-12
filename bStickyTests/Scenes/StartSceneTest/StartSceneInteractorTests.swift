//
//  ChooseTagInteractorTests.swift
//  bStickyTests
//
//  Created by mima on 20/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class StartSceneInteractorTests: XCTestCase {
    
    // Subject Under Test
    var sut: StartSceneInteractor!
    
    // Test Lifecycle
    override func setUp() {
        super.setUp()
        setupStartSceneInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupStartSceneInteractor() {
       sut = StartSceneInteractor()
    }
    
    class StartScenePresentationLogicSpy: StartBeePresentationLogic {
        
        // Method call expectations
        var presentFetchedTagsCalled = false
        var presentStartCreateStickyCalled = false
        var presentStartManageTagCalled = false

        // Spied methods
        func presentFetchedTags(response: StartBee.FetchTags.Response) {
            presentFetchedTagsCalled = true
        }
        
        func presentStartCreateSticky(response: StartBee.StartCreateSticky.Response) {
            presentStartCreateStickyCalled = true
        }
        
        func presentStartListStickies(response: StartBee.StartListStickies.Response) {
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
            compeletionHandler(Seeds.Tags.tags)
        }
    }
    // Tests
    func testFetchTagsShouldAskBeeWorkerToFetchTagsAndPresenterToFormatResult(){
        // Given
        let startScenePresentationLogicSpy = StartScenePresentationLogicSpy()
        sut.presenter = startScenePresentationLogicSpy
        //let stickyWorkerSpy = StickyWorkerSpy(stickyDB: StickyMemDB())
        let beeWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = beeWorkerSpy
        
        // When
        let request = StartBee.FetchTags.Request()
        sut.fetchTags(request: request)
        
        // Then
        XCTAssert(beeWorkerSpy.fetchTagsCalled, "fetchTags() should ask StickyWorker to fetch tags")
        XCTAssert(startScenePresentationLogicSpy.presentFetchedTagsCalled, "fetchTags() should ask presenter to format tags result")
    }
    
    func testStartCreateStickyShouldCallPresenter() {
        // Given
        let startScenePresentationLogicSpy = StartScenePresentationLogicSpy()
        sut.presenter = startScenePresentationLogicSpy
        
        // When
        let request = StartBee.StartCreateSticky.Request(tagId: 44, tagColor: "#FFFFFF")
        sut.startCreateSticky(request: request)
        
        // Then
        XCTAssert(startScenePresentationLogicSpy.presentStartCreateStickyCalled, "startCreateSticky() should call presenter")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
