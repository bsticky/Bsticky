//
//  StartBeePresenterTests.swift
//  bStickyTests
//
//  Created by mima on 2021/08/10.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class StartBeePresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: StartBeePresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupStartBeePresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupStartBeePresenter() {
        sut = StartBeePresenter()
    }
    
    // MARK: Test doubles
    
    class StartBeeDisplayLogicSpy: StartBeeDisplayLogic {
        var numberOfTags: Int = 6
        
        // Method call expectations
        var displayFetchedTagsCalled = false
        var displayManageTagCalled = false
        var displayCreateStickyCalled = false
        var displayListStickiesCalled = false
        
        // Argument expectations
        var fetchedTagsViewModel: StartBee.FetchTags.ViewModel!
        var startManageTagViewModel: StartBee.StartManageTag.ViewModel!
        var startCreateTagViewModel: StartBee.StartCreateSticky.ViewModel!
        var startListStickiesViewModel: StartBee.StartListStickies.ViewModel!
        
        // Spied methods
        func displayFetchedTags(viewModel: StartBee.FetchTags.ViewModel) {
            displayFetchedTagsCalled = true
            self.fetchedTagsViewModel = viewModel
        }
        
        func displayManageTag(viewModel: StartBee.StartManageTag.ViewModel) {
            displayManageTagCalled = true
            self.startManageTagViewModel = viewModel
        }
        
        func displayCreateSticky(viewModel: StartBee.StartCreateSticky.ViewModel) {
            displayCreateStickyCalled = true
            self.startCreateTagViewModel = viewModel
        }
        
        func displayListStickies(viewModel: StartBee.StartListStickies.ViewModel) {
            displayListStickiesCalled = true
            self.startListStickiesViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    func testpresentFetchedTagShouldResponseWithSameNumberOfTagFromStartBeeViewController() {
        // Given
        let startBeeDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startBeeDisplayLogicSpy
        
        // When
        let response = StartBee.FetchTags.Response(tags: [])
        sut.presentFetchedTags(response: response)
        
        // Then
        let displayedTags = startBeeDisplayLogicSpy.fetchedTagsViewModel.displayedTags
        XCTAssertEqual(displayedTags.count, startBeeDisplayLogicSpy.numberOfTags, "Present Tags should return same number of tags defined in StartBeeViewController")
    }
    
    func testPresentFetchedTagsShouldFormatFetchedTagsForDisplay() {
        // Given
        let startBeeDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startBeeDisplayLogicSpy
        
        // When
        let response = StartBee.FetchTags.Response(tags: [Seeds.Tags.tagOne, Seeds.Tags.tagTwo])
        sut.presentFetchedTags(response: response)
        
        // Then
        let displayedTags = startBeeDisplayLogicSpy.fetchedTagsViewModel.displayedTags
        XCTAssertEqual(displayedTags[0].id, 1)
        XCTAssertEqual(displayedTags[0].name, "TagOne")
        XCTAssertEqual(displayedTags[0].color, "#FF1D00")
        XCTAssertEqual(displayedTags[3].id, 0)
        XCTAssertEqual(displayedTags[3].name, "")
        XCTAssertEqual(displayedTags[3].color, "#F4116F")
    }
    
    func testPresentFetchedTagShouldAskViewControllerToDisplayFetchedTags() {
        // Given
        let startBeeDisplayLogicSpy = StartBeeDisplayLogicSpy()
        sut.viewController = startBeeDisplayLogicSpy
        
        // When
        let response = StartBee.FetchTags.Response(tags: [])
        sut.presentFetchedTags(response: response)
        
        // Then
        XCTAssert(startBeeDisplayLogicSpy.displayFetchedTagsCalled)
    }
    
    func testPresentManageTagShouldAskViewControllerToDisplayManageTag() {
        
    }
    
}
