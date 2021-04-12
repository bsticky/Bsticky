//
//  StartSceneViewControllerTests.swift
//  bStickyTests
//
//  Created by mima on 22/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest
import UIKit

class StartSceneViewControllerTests: XCTestCase {
    
    // Subject under test
    var sut: StartBeeViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupStartSceneViewController()
    }
    
    override func tearDown() {
        window = nil
        sut = nil
        super.tearDown()
    }
    
    func setupStartSceneViewController() {
        sut = StartBeeViewController()
        sut.loadViewIfNeeded()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // Interactor Spy
    class StartSceneBusinessLogicSpy: StartBeeBusinessLogic {
        // Method call expectations
        var fetchTagsCalled = false
        var startCreateStickyCalled = false
        var startListStickiesCalled = false
        var startManageTagCalled = false
        
        // Argument expectations
        var startCreateStickyRequest: StartBee.StartCreateSticky.Request!
        
        func fetchTags(request: StartBee.FetchTags.Request) {
            fetchTagsCalled = true
        }
        
        func startCreateSticky(request: StartBee.StartCreateSticky.Request) {
            startCreateStickyCalled = true
            self.startCreateStickyRequest = request
        }
        
        func startListStickies(request: StartBee.StartListStickies.Request) {
        }
        
        func startManageTag(request: StartBee.StartManageTag.Request) {
           startManageTagCalled = true
        }
    }
    
    class StartBeeRouterSpy: StartBeeRoutingLogic {
        
        // MARK: Method call expectations
        
        var routeToCreateStickyCalled = false
        var routeToManageTagCalled = false
        var routeToListStickiesCalled = false
        
        // MARK:  Spied methods
        
        func routeToCreateSticky() {
            routeToCreateStickyCalled = true
        }
        
        func routeToManageTag() {
            routeToManageTagCalled = true
        }
        
        func routeToListStickies() {
            routeToListStickiesCalled = true
        }
    }

    // MARK: - Tests

    func testShouldFetchTagsWhenViewDidAppear() {
        // Given
        let startSceneBusinessLogicSpy = StartSceneBusinessLogicSpy()
        sut.interactor = startSceneBusinessLogicSpy
        loadView()
        
        // When
        sut.viewDidAppear(true)
        
        // Then
        XCTAssert(startSceneBusinessLogicSpy.fetchTagsCalled, "Should fetch tags right after the view appears")
    }
    
    func testDisplayFetchedTagsShouldUpdateTagButtons() {
        // Given
        let startSceneBusinessLogicSpy = StartSceneBusinessLogicSpy()
        sut.interactor = startSceneBusinessLogicSpy
        loadView()
        
        // When
        let displayedTags = StartBee.FetchTags.ViewModel(displayedTags: Seeds.DisplayedTag.displayedTags)
        sut.displayFetchedTags(viewModel: displayedTags)
        sut.tagButtonTapped(tagId: 1, tagColor: UIColor.white)

        // Then
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].tagId, 1, "Displaying an tag should update the tagId")
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].title(for: .normal), "One", "Displaying the tag should update the tag button title")
        XCTAssertEqual(sut.tagContainerView.tagButtons[0].backgroundColor, UIColor("#FF1D00"), "Displaying the tag should update the background color")
        
        XCTAssert(startSceneBusinessLogicSpy.startCreateStickyCalled, "Displaying the Tag should set the action")
    }
    
    // Start ManageTag scene
    func testTagButtonLongTappedShouldStartManageTag() {
        // Given
        let startSceneBusinessLogicSpy = StartSceneBusinessLogicSpy()
        sut.interactor = startSceneBusinessLogicSpy
        loadView()
        
        // When
        sut.tagButtonLongTapped(tagId: 0, tagPosition: 2)
        
        // Then
        XCTAssert(startSceneBusinessLogicSpy.startManageTagCalled, "It shoud start a ManageTag Scene when the user long tap the tag")
    }

    // Start CreateSticky scene
    func testTagButtonTappedShouldStartCreateSticky() {
        // Given
        let startSceneBuisinessLogicSpy = StartSceneBusinessLogicSpy()
        sut.interactor = startSceneBuisinessLogicSpy
        loadView()
        
        // When
        sut.tagButtonTapped(tagId: 0, tagColor: UIColor.white)

        // Then
        XCTAssert(startSceneBuisinessLogicSpy.startCreateStickyCalled, "It should start a CreateSticky Scene when the user tap the tag")
    }
    
    // Start ListStickies scene
    /*
    func testTagdragedToCenterShouldStartCreateSticky() {
        // Given
        loadView()
        let startSceneBuisinessLogicSpy = StartSceneBusinessLogicSpy()
        sut.interactor = startSceneBuisinessLogicSpy
        
        // When
        sut.tagDraggedtoCenter(self)
        
        // Then
        //XCTAssert(startSceneBuisinessLogicSpy.startListStickiesCalled, "It should start a ListsStickies Scene when the user dragged tag to the center")
    }
    */
    


    // *** UseCase : StartCreateSticky [4]*** //
    /*
    func testDisplayFinishedCreatStickyShouldRouteToCreateStickyScene() {
        // Given
        loadView()
        let startSceneRouterSpy = StartBeeRouterSpy()
        sut.router = startSceneRouterSpy as! StartBeeDataPassing & StartBeeRoutingLogic
        
        // When
        let viewModel = StartBee.StartCreateSticky.ViewModel(tagId: 44)
        sut.displayFinishedCreateSticky(viewModel: viewModel)
        
        // Then
        XCTAssert(startSceneRouterSpy.routeToCreateStickyCalled, "Displaying a FinishedCreatSticky should navigate to the CreateSticky scene")
    }
    */
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
