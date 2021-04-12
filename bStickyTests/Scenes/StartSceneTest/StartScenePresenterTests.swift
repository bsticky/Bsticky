//
//  ChooseTagPresenterTests.swift
//  bStickyTests
//
//  Created by mima on 20/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class StartBeePresenterTests: XCTestCase {
    // Subject under test
    var sut: StartBeePresenter!
    
    override func setUp() {
        super.setUp()
        setupStartBeePresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupStartBeePresenter() {
        sut = StartBeePresenter()
    }
    
    class StartBeeDisplayLogicSpy: StartBeeDisplayLogic {
        func displayManageTag(viewModel: StartBee.StartManageTag.ViewModel) {
        }
        
        func displayCreateSticky(viewModel: StartBee.StartCreateSticky.ViewModel) {
        }
        
        func displayListStickies(viewModel: StartBee.StartListStickies.ViewModel) {
        }
        
        func displayCreateStickyScene(viewmodel: StartBee.StartCreateSticky.ViewModel) {
        }
        
        func displayManageTagScene(viewModel: StartBee.StartManageTag.ViewModel) {
        }
        
        var numberOfTags: Int = 6

        // Method call expectations
        var displayFetchedTagsCalled = false
        var displayFinishedCreateStickyCalled = false
        
        // Argument expectations
        var displayFetchedTagsViewModel: StartBee.FetchTags.ViewModel!
        var finishedCreateStickyViewModel: StartBee.StartCreateSticky.ViewModel!

        func displayFetchedTags(viewModel: StartBee.FetchTags.ViewModel) {
            displayFetchedTagsCalled = true
            self.displayFetchedTagsViewModel = viewModel
        }
        
        func displayFinishedCreateSticky(viewModel: StartBee.StartCreateSticky.ViewModel) {
            displayFinishedCreateStickyCalled = true
            self.finishedCreateStickyViewModel = viewModel
        }
        
        func displayFinishedListStickies(viewModel: StartBee.StartListStickies.ViewModel) {
        }
        
        func displayFinishedEditTag(viewModel: StartBee.StartManageTag.ViewModel) {
        }
    }
    
    // Tests
    
    // FetchTags
    func testPresentFetchedTagsShouldAskViewControllerToDisplayFetchedTags() {
        // Given
        let startSceneDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startSceneDisplayLogicSpy
        
        // When
        let response = StartBee.FetchTags.Response(tags: Seeds.Tags.tags)
        sut.presentFetchedTags(response: response)
        
        // Then
        XCTAssert(startSceneDisplayLogicSpy.displayFetchedTagsCalled, "Presenting fetched tags should ask view controller to display them")
        
    }
    
    func testPresentFetchedTagShouldAppendDefaultTagandReturnDisplayedTags() {
        // Given
        let startSceneDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startSceneDisplayLogicSpy

        // When
        var tags: [Tag] = []
        tags.append(Seeds.Tags.tags[0])
        sut.presentFetchedTags(response: StartBee.FetchTags.Response(tags: tags))
        let displayedTags = startSceneDisplayLogicSpy.displayFetchedTagsViewModel.displayedTags
        
        // Then
        XCTAssertEqual(displayedTags.count, startSceneDisplayLogicSpy.numberOfTags)
        XCTAssertEqual(displayedTags[0].id, 1)
        XCTAssertEqual(displayedTags[0].name, "One")
        XCTAssertEqual(displayedTags[0].color, "#FF1D00")
        XCTAssertEqual(displayedTags[1].id, 0)
        XCTAssertEqual(displayedTags[1].name, "")
        XCTAssertEqual(displayedTags[1].color, "#FF1D00")
    }
    
    func testPresentFetchedTagShouldNotReturnDeactivatediTag() {
        // Given
        let startSceneDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startSceneDisplayLogicSpy
        
        // When
        var tags: [Tag] = []
        let deactivatedTag: Tag = Tag(id: 0, name: "deactivatedTag", color: "#000000", position: 1, activated: false, createdDate: 0, description: "")
        tags.append(deactivatedTag)

        sut.presentFetchedTags(response: StartBee.FetchTags.Response(tags: tags))
        let displayedTags = startSceneDisplayLogicSpy.displayFetchedTagsViewModel.displayedTags
        
        // Then
        XCTAssertEqual(displayedTags[0].id, 0)
        XCTAssertEqual(displayedTags[0].name, "")
        XCTAssertEqual(displayedTags[0].color, "#FF1D00")
    }
    
    
    // StartCreateSticky
    func testPresentStartCreateStickyShouldAskViewControllerToDisplayFinishedCreateSticky() {
        // Given
        let startSceneDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startSceneDisplayLogicSpy

        // When
        let response = StartBee.StartCreateSticky.Response()
        sut.presentStartCreateSticky(response: response)
        
        // Then
        XCTAssert(startSceneDisplayLogicSpy.displayFinishedCreateStickyCalled, "Presenting startCreateSticky should ask view controller to displayFinishedStartCreateSticky.")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
