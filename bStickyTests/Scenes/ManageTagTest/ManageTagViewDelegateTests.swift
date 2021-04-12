//
//  ManageTagViewDelegateTests.swift
//  bStickyTests
//
//  Created by mima on 2021/01/30.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class ManageTagViewDelegateTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ManageTagView!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupManageTagView()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupManageTagView() {
        sut = ManageTagView()
    }
    
    // MARK: - ViewController spy
    
    class ManageTagViewControllerSpy: ManageTagViewController {
        
        // Method call expectations
        
        var saveButtonTappedCalled = false
        var closeButtonTappedCalled = false
        var cancelButtonTappedCalled = false
        var doneButtonTappedCalled = false
        var deleteButtonTappedCalled = false
        
        // Spied methods
        
        override func saveButtonTapped(_ sender: Any, tagFormFields: ManageTag.TagFormFields) {
            saveButtonTappedCalled = true
        }
        override func closeButtonTapped(_ sender: Any) {
            closeButtonTappedCalled = true
        }
        override func cancelButtonTapped(_ sender: Any) {
            cancelButtonTappedCalled = true
        }
        override func doneButtonTapped(_ sender: Any, tagFormFields: ManageTag.TagFormFields) {
            doneButtonTappedCalled = true
        }
        override func deleteButtonTapped(_ sender: Any, tagId: Int) {
            deleteButtonTappedCalled = true
        }
    }
    
    func testSaveButtonTappedShouldCallViewControllersaveButtonTapped(){
        // Given
        let manageTagViewControllerSpy = ManageTagViewControllerSpy()
        manageTagViewControllerSpy.manageTagView = sut
        manageTagViewControllerSpy.manageTagView.delegate = manageTagViewControllerSpy
        
        // When
        sut.navSaveButtonTapped(self)
        
        // Then
        XCTAssert(manageTagViewControllerSpy.saveButtonTappedCalled)
    }
    
    func testCloseButtonTappedShouldCallViewControllerCloseButtonTapped(){
        // Given
        let manageTagViewControllerSpy = ManageTagViewControllerSpy()
        manageTagViewControllerSpy.manageTagView = sut
        manageTagViewControllerSpy.manageTagView.delegate = manageTagViewControllerSpy
        
        // When
        sut.navCloseButtonTapped(self)

        // Then
        XCTAssert(manageTagViewControllerSpy.closeButtonTappedCalled)
    }
    
    func testCancelButtonTappedShouldCallViewControllerCancelButtonTapped(){
        // Given
        let manageTagViewControllerSpy = ManageTagViewControllerSpy()
        manageTagViewControllerSpy.manageTagView = sut
        manageTagViewControllerSpy.manageTagView.delegate = manageTagViewControllerSpy
        
        // When
        sut.navCancelButtonTapped(self)

        // Then
        XCTAssert(manageTagViewControllerSpy.cancelButtonTappedCalled)
    }

    func testDoneButtonTappedShouldCallViewControllerDoneButtonTapped(){
        // Given
        let manageTagViewControllerSpy = ManageTagViewControllerSpy()
        manageTagViewControllerSpy.manageTagView = sut
        manageTagViewControllerSpy.manageTagView.delegate = manageTagViewControllerSpy
        
        // When
        sut.navDoneButtonTapped(self)

        // Then
        XCTAssert(manageTagViewControllerSpy.doneButtonTappedCalled)
    }
    
    /*
    func testDeleteButtonTappedShouldCallViewControllerDeleteButtonTapped(){
        // Given
        let manageTagViewControllerSpy = ManageTagViewControllerSpy()
        manageTagViewControllerSpy.manageTagView = sut
        manageTagViewControllerSpy.manageTagView.delegate = manageTagViewControllerSpy
        

        // Then
        XCTAssert(manageTagViewControllerSpy.doneButtonTappedCalled)
    }
    */
}
