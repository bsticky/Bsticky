//
//  CreateStickyPresenterTests.swift
//  bStickyTests
//
//  Created by mima on 18/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class CreateStickyPresenterTests: XCTestCase {
    var sut: CreateStickyPresenter!
    
    override func setUp() {
        super.setUp()
        setupCreateStickyPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupCreateStickyPresenter() {
        sut = CreateStickyPresenter()
    }
    
    class CreateStickyDisplayLogicSpy: CreateStickyDisplayLogic{

        // Method call expectations
        var displayCreatedStickyCalled = false
        var displayStickyToEditCalled = false
        var displayUpdatedStickyCalled = false
        var displayTagAttributeCalled = false
        
        // Argument expectations
        var createStickyViewModel: CreateSticky.CreateSticky.ViewModel!
        var editStickyViewModel: CreateSticky.EditSticky.ViewModel!
        var updateStickyViewModel: CreateSticky.UpdateSticky.ViewModel!
        
        // Spied methods
        func displayCreatedSticky(viewModel: CreateSticky.CreateSticky.ViewModel) {
            displayCreatedStickyCalled = true
            self.createStickyViewModel = viewModel
        }
        
        func displayStickyToEdit(viewModel: CreateSticky.EditSticky.ViewModel) {
            displayStickyToEditCalled = true
            self.editStickyViewModel = viewModel
        }
        
        func displayUpdatedSticky(viewModel: CreateSticky.UpdateSticky.ViewModel) {
            displayUpdatedStickyCalled = true
            self.updateStickyViewModel = viewModel
        }
        
        func displayTagAttribute(viewModel: CreateSticky.SetTagAttribute.ViewModel) {
            displayTagAttributeCalled = true
        }
    }
    
    // Test - create sticky
    
    func testPresentCreatedStickyShouldAskViewControllerToDisplayTheNewlyCreatedSticky() {
        // Given
        let createdStickyDisplayLogicSpy = CreateStickyDisplayLogicSpy()
        sut.viewController = createdStickyDisplayLogicSpy
        
        // When
        let sticky = Seeds.Stickies.textSticky
        let response = CreateSticky.CreateSticky.Response(sticky: sticky)
        sut.presentCreateSticky(response: response)
        
        // Then
        XCTAssert(createdStickyDisplayLogicSpy.displayCreatedStickyCalled, "Presenting the newly created sticky should ask view controller to display it")
        XCTAssertNotNil(createdStickyDisplayLogicSpy.createStickyViewModel.sticky, "Presenting the newly created sticky should succed")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
