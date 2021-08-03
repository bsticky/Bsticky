//
//  StartBeeViewControllerTests.swift
//  bStickyTests
//
//  Created by mima on 2021/08/03.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class StartBeeViewControllerTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: StartBeeViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupStartBeeViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupStartBeeViewController() {
        sut = StartBeeViewController()
        sut.loadViewIfNeeded()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class StartBeeBusinessLogicSpy: StartBeeBusinessLogic {
        
        // Method call expectations
        var fetchTagsCalled = false
        var startManageTagCalled = false
        var startCreateStickyCalled = false
        var startListStickiesCalled = false
        
        // Spied methods
        func fetchTags(request: StartBee.FetchTags.Request) {
            fetchTagsCalled = true
        }
        
        func startManageTag(request: StartBee.StartManageTag.Request) {
            startManageTagCalled = true
        }
        
        func startCreateSticky(request: StartBee.StartCreateSticky.Request) {
            startCreateStickyCalled = true
        }
        
        func startListStickies(request: StartBee.StartListStickies.Request) {
            startListStickiesCalled = true
        }
    }
    
    class StartBeeRouterSpy: StartBeeRouter {
        
        // Method call expectations
        var routeToManageTagCalled = false
        var routeToCreateStickyCalled = false
        var routeToListStickiesCalled = false
        var routeToSettingsCalled = false
        
        // Spied methods
        override func routeToManageTag() {
            routeToManageTagCalled = true
        }
        
        override func routeToCreateSticky() {
            routeToCreateStickyCalled = true
        }
        
        override func routeToListStickies() {
            routeToListStickiesCalled = true
        }
        
        override func routeToSettings() {
            routeToSettingsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldFetchTagsWhenViewDidAppear() {
        // Given
        let startBeeBusinessLogicSpy = StartBeeBusinessLogicSpy()
        sut.interactor = startBeeBusinessLogicSpy
        loadView()
        
        // When
        sut.viewDidAppear(true)
        
        // Then
        XCTAssert(startBeeBusinessLogicSpy.fetchTagsCalled, "Should fetch tags right after the view appears")
    }
    
    func testDisplayFetchedTagsShouldUpdateTagButtons() {
        // Given
        let startBeeBusinessLogicSpy = StartBeeBusinessLogicSpy()
        sut.interactor = startBeeBusinessLogicSpy
        loadView()
        
        // When
        let viewModel = StartBee.FetchTags.ViewModel(displayedTags: Seeds.DisplayedTags.displayedTags)
        sut.displayFetchedTags(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].tagId, 1, "Displaying tag update the tagId")
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].titleLabel?.text, "TagOne")
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].backgroundColor!.toHex, "FF1D00")
        
        XCTAssertEqual(sut.tagContainerView.tagButtons[5].tagId, 6)
        XCTAssertEqual(sut.tagContainerView.tagButtons[5].titleLabel?.text, "TagSix")
        XCTAssertEqual(sut.tagContainerView.tagButtons[5].backgroundColor!.toHex, "B72AFF")
    }
    
    func testTagButtonLongTappedShouldStartManageTag() {
        // Given
        let startBeeBusinessLogicSpy = StartBeeBusinessLogicSpy()
        sut.interactor = startBeeBusinessLogicSpy
        loadView()
        
        // When
        sut.tagButtonLongTapped(tagId: 1, tagPosition: 0)
        
        // Then
        XCTAssert(startBeeBusinessLogicSpy.startManageTagCalled)
    }
    
    func testDisplayManageTagShouldRouteToManageTag() {
        // Given
        let startBeeRouterSpy = StartBeeRouterSpy()
        sut.router = startBeeRouterSpy
        loadView()
        
        // When
        let viewModel = StartBee.StartManageTag.ViewModel()
        sut.displayManageTag(viewModel: viewModel)
        
        // Then
        XCTAssert(startBeeRouterSpy.routeToManageTagCalled)
    }
    
}