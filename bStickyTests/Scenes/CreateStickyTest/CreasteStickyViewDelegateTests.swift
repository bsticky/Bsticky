//
//  CreasteStickyViewDelegateTests.swift
//  bStickyTests
//
//  Created by mima on 2021/01/30.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class CreasteStickyViewDelegateTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: CreateStickyView!
    var window: UIWindow!

    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupCreateStickyView()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupCreateStickyView() {
        sut = CreateStickyView()
    }
    
    func loadView() {
        window.addSubview(sut)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - ViewController spy
    
    class CreateStickyViewControllerSpy: CreateStickyViewController {
        
        // Method call expectations
        
        var swipedRightCalled = false
        var swipedLeftCalled = false
        var cameraButtonTappedCalled = false
        var recordingButtonTapped = false

        // Spied methods
        override func swipedRight() {
           swipedRightCalled = true
        }
        override func swipedLeft() {
            swipedLeftCalled = true
        }
        override func cameraButtopTapped(_ sender: Any) {
            cameraButtonTappedCalled = true
        }
        override func recordingButtonTapped(_ sender: Any) {
            recordingButtonTapped = true
        }
    }
    
    // test swiped actions
    func testSwipedRightShouldCallViewControllerswipedRight(){
        // Given
        sut.cameraButtonTapped(self)
        let createStickyViewControllerSpy = CreateStickyViewControllerSpy()
        createStickyViewControllerSpy.createStickyView = sut
        createStickyViewControllerSpy.createStickyView.delegate = createStickyViewControllerSpy

        // When
        sut.swipedLeft()
        
        // Then
        XCTAssert(createStickyViewControllerSpy.swipedLeftCalled)
    }
    
    func testSwipedLeftShouldCallViewControllerswipedLeft() {
        // Given
        sut.cameraButtonTapped(self)
        let createStickyViewControllerSpy = CreateStickyViewControllerSpy()
        createStickyViewControllerSpy.createStickyView = sut
        createStickyViewControllerSpy.createStickyView.delegate = createStickyViewControllerSpy
        
        // When
        sut.swipedLeft()
        
        // Then
        XCTAssert(createStickyViewControllerSpy.swipedLeftCalled)
    }
    
    // test camera button
    func testCameraButtonTappedShouldCallViewControllerCameraButtonTapped(){
        // Given
        sut.cameraButtonTapped(self)
        let createStickyViewControllerSpy = CreateStickyViewControllerSpy()
        sut.delegate = createStickyViewControllerSpy
        
        // When
        sut.cameraButtonTapped(self)
        
        // Then
        XCTAssert(createStickyViewControllerSpy.cameraButtonTappedCalled)
    }
    
    // test recording button
    func testRecordingButtonTappedShouldCallViewControllerRecordingButtonTapped() {
        // Given
        sut.cameraButtonTapped(self)
        let createStickyViewControllerSpy = CreateStickyViewControllerSpy()
        sut.delegate = createStickyViewControllerSpy
        
        // When
        sut.recordingButtonTapped(self)
        
        // Then
        XCTAssert(createStickyViewControllerSpy.recordingButtonTapped)
    }
}
