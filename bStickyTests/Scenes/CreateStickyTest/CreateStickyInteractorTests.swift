//
//  CreateStickyInteractorTests.swift
//  bStickyTests
//
//  Created by mima on 18/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class CreateStickyInteractorTests: XCTestCase {
    // Subject under test
    var sut: CreateStickyInteractor!
    
    override func setUp() {
        super.setUp()
        setupCreateStickyInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupCreateStickyInteractor() {
        sut = CreateStickyInteractor()
    }
    
    class CreateStickyPresentationLogicSpy: CreateStickyPresentationLogic {

        var presentCreatedStickyCalled = false
        var presentStickyToeditCalled = false
        var presentUpdatedStickyCalled = false
        var presentTagAttributeCalled = false
        
        func presentCreateSticky(response: CreateSticky.CreateSticky.Response) {
            presentCreatedStickyCalled = true
        }
        
        func presentStickyToEdit(response: CreateSticky.CreateSticky.Response) {
            presentStickyToeditCalled = true
        }
        
        func presentUpdatedSticky(response: CreateSticky.UpdateSticky.Response) {
            presentUpdatedStickyCalled = true
        }
        
        func presentTagAttribute(response: CreateSticky.SetTagAttribute.Response) {
            presentTagAttributeCalled = true
        }
    }
    
    class BeeWorkerSpy: BeeWorker {
        var createStickyCalled = false
        var updatedStickyCalled = false
        
        override func createSticky(stickyToCreate: Sticky, completionHandler: @escaping (Sticky?) -> Void) {
            createStickyCalled = true
            completionHandler(Seeds.Stickies.imageSticky)
        }
    }
    
    func testCreateStickyshouldAskStickyWorkerToCreateTheNewStickyAndPresenterToFormatIt() {
        // Given
        let createStickyPresentationLogicSpy = CreateStickyPresentationLogicSpy()
        sut.presenter = createStickyPresentationLogicSpy
        let stickyWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = stickyWorkerSpy
        sut.tagId = 0
        
        // When
        let request = CreateSticky.CreateSticky.Request(stickyFormFields: CreateSticky.StickyFormFields(id: 0, contentsType: 1, text: "", filePath: "", contentsAttributeId: 0, createdDate: 0, updatedDate: 0))
        sut.createSticky(request: request)
        
        // Then
        XCTAssert(stickyWorkerSpy.createStickyCalled, "CreateSticky() should ask StickyWorker to create the new Sticky")
        XCTAssert(createStickyPresentationLogicSpy.presentCreatedStickyCalled, "createdSticky() should ask presenter to format the newly created sticky")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
