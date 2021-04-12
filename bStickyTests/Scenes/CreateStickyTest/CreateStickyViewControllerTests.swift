//
//  CreateStickyViewControllerTests.swift
//  bStickyTests
//
//  Created by mima on 18/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class CreateStickyViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: CreateStickyViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupCreateStickyViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupCreateStickyViewController() {
        sut = CreateStickyViewController()
        sut.loadViewIfNeeded()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Interactor spy
    
    class CreateStickyBuisinessLogicSpy: CreateStickyBusinessLogic{
        
        // Method call expectations
        
        var createStickyCalled = false
        var updateStickyCalled = false
        var setTagAttributesCalled = false
        
        // Argument expectations
        
        var createStickyRequest: CreateSticky.CreateSticky.Request!
        var updateStickyRequest: CreateSticky.CreateSticky.Request!

        var stickyToEdit: Sticky?
        var tagColor: String?
        
        // Spied methods
       
        func createSticky(request: CreateSticky.CreateSticky.Request) {
            createStickyCalled = true
            self.createStickyRequest = request
        }
        
        func updateSticky(request: CreateSticky.UpdateSticky.Request) {
            self.updateStickyCalled = true
        }
        
        func setTagAttribute(request: CreateSticky.SetTagAttribute.Request) {
            setTagAttributesCalled = true
        }
    }
    
    // MARK: - Router spy
    
    class CreateStickyRouterSpy: CreateStickyRouter {
        
        // Method call expectations
        
        var routeToStartBeeCalled = false
        
        // Spied methods
        
        override func routeToStartBee() {
            routeToStartBeeCalled = true
        }
    }
    

    // MARK: - Tests
    
    // SwipedToLeft to create sticky
    func testSwipeToLeftShouldCreateSticky() {
        // Given
        loadView()
        let createStickyBusinessLogicSpy = CreateStickyBuisinessLogicSpy()
        sut.interactor = createStickyBusinessLogicSpy
        
        // When
        sut.swipedLeft()

        // Then
        XCTAssert(createStickyBusinessLogicSpy.createStickyCalled, "It should create a new sticky when the user swipe the view to the left")
    }
    
    // SwipedToRight route to start bee
    func testSwiptedToRightShouldRouteToStartBee() {
        // Given
        loadView()
        let createStickyRouterSpy = CreateStickyRouterSpy()
        sut.router = createStickyRouterSpy
        
        // When
        sut.swipedRight()
        
        // Then
        XCTAssert(createStickyRouterSpy.routeToStartBeeCalled, "Swiped view to the right should navigate back to the StartBee scene")
    }
    
    // MARK: - Camera
    
    func testCameraButtonTappedSHouldInitCameraController() {
        // Given
        loadView()
        window.rootViewController = sut
        window.makeKeyAndVisible()

        // When
        sut.cameraButtopTapped(self)
        
        // Then
        XCTAssert(sut.presentedViewController is BeeCameraController)
    }
    
    func testCameraControllestickButtonTappedShouldCreateStickyWithFilePath() {
        // Given
        loadView()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        let camera = BeeCameraController()
        camera.delegate = sut
        let createStickyBusinessLogicSpy = CreateStickyBuisinessLogicSpy()
        sut.interactor = createStickyBusinessLogicSpy
        
        // When
        camera.stickButtonTapped(image: UIImage(named: "camera"))
        
        // Then
        XCTAssert(createStickyBusinessLogicSpy.createStickyCalled, "It should create a new sticky when the user tapped stick button in camera controller")
        XCTAssertNotNil(createStickyBusinessLogicSpy.createStickyRequest.stickyFormFields.filePath, "File Path should not be nil")
    }
    
    /*
    // MARK: - Test background color ! change logic flow.
    func testShouldSetBackgroundColorWhenLoadView() {
    }
    
    // need to test save button tapped or gesture to create sticky
    */

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
