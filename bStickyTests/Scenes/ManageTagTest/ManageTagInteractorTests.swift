//
//  ManageTagInteractorTests.swift
//  bStickyTests
//
//  Created by mima on 06/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class ManageTagInteractorTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: ManageTagInteractor!
    
    
    // MARK: -  Test lifecycle
    override func setUp() {
        super.setUp()
        setupManageTagInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Test setup
    func setupManageTagInteractor() {
        sut = ManageTagInteractor()
        sut.chosenTagButtonPosition = 0
    }
    
    // MARK: -  Presenter spy
    class ManageTagPresentationLogicSpy: ManageTagPresentationLogic {
        
        // Method call expectations
        var presentTagToEditCalled = false
        var presentTagsToChooseCalled = false
        var presentCreateTagCalled = false
        var presentUpdatedTagCalled = false
        var presentDeletedTagCalled = false
        
        // Argument expectations
        var presentTagToEditResponse: ManageTag.EditTag.Response!
        
        // Spied methods
        func presentTagToEdit(response: ManageTag.EditTag.Response) {
            presentTagToEditCalled = true
            presentTagToEditResponse = response
        }
        
        func presentTagsToChoose(response: ManageTag.ChooseTag.Response) {
            presentTagsToChooseCalled = true
        }
        
        func presentCreatedTag(response: ManageTag.CreateTag.Response) {
            presentCreateTagCalled = true
        }

        func presentUpdatedTag(response: ManageTag.UpdateTag.Response) {
            presentUpdatedTagCalled = true
        }
        
        func presentDeletedTag(response: ManageTag.DeleteTag.Response) {
            presentDeletedTagCalled = true
        }
    }
    
    // MARK: - BeeWorkerSpy
    class BeeWorkerSpy: BeeWorker {
        
        // Method call expactations
        var createTagCalled = false
        var updateTagCalled = false
        var deleteTagCalled = false
        
        // Spied methods
        override func createTag(tagToCreate: Tag, completionHandler: @escaping (Tag?) -> Void) {
            createTagCalled = true
            completionHandler(Seeds.Tags.tags[0])
        }
        
        override func updatedTag(tagToUpdate: Tag, completionHandler: @escaping (Tag?) -> Void) {
            updateTagCalled = true
            completionHandler(Seeds.Tags.tags[0])
        }
        
        override func deleteTag(tagId: Int, completionHandler: @escaping (Int?) -> Void) {
            deleteTagCalled = true
            completionHandler(0)
        }
    }

    
    // MARK: - Tests
    
    /// Show tag to edit should ask presenter to format the exisint tag
    func testShowTagToEditShouldAskPresenterToFormatTheExistingTag() {
        // Given
        let manageTagPresentationLogiSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogiSpy
        sut.chosenTagId = 1
        sut.tagsToChoose = [Seeds.Tags.tags[0]]
        
        // When
        let request = ManageTag.EditTag.Request()
        sut.showTagToEdit(request: request)
        
        // Then
        XCTAssert(manageTagPresentationLogiSpy.presentTagToEditCalled, "ShowTagToEdit should ask presenter to format existing tag")
    }
    
    /// Show tag to edit should find tag with chosen tagid from tags to choose
    func testShowTagToEditShouldFindTagwithChoosenTagIdFromTagsToChoose() {
        // Given
        let manageTagPresentationLogiSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogiSpy
        sut.chosenTagId = 1
        sut.tagsToChoose = Seeds.Tags.tags
        
        // When
        let request = ManageTag.EditTag.Request()
        sut.showTagToEdit(request: request)
        
        // Then
        let tagToEdit = manageTagPresentationLogiSpy.presentTagToEditResponse.tag
        XCTAssertEqual(tagToEdit.id, 1)
        XCTAssertEqual(tagToEdit.name, "One")
        XCTAssertEqual(tagToEdit.color, "#FF1D00")
        XCTAssertEqual(tagToEdit.position, 1)
        XCTAssertEqual(tagToEdit.activated, true)
        XCTAssertEqual(tagToEdit.createdDate, 20201222)
        XCTAssertEqual(tagToEdit.description, "-")
    }
    
    /// show tags to choose should ask presenter to format exising tags
    func testShowTagsToChooseShouldAskPresenterToFormatTheExistingTags() {
        // Given
        let manageTagPresentationLogiSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogiSpy
        sut.chosenTagId = 1
        
        // When
        let request = ManageTag.ChooseTag.Request()
        sut.showTagsToChoose(request: request)

        // Then
        XCTAssert(manageTagPresentationLogiSpy.presentTagsToChooseCalled, "ShowTagsToChoose should ask presenter to format existing tags")
    }
    
    // Create tag
    func testCreateTagShouldAskBeeWorkerToCreateTheNewTagAndPresenterToFormatIt() {
        // Given
        let manageTagPresentationLogicSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogicSpy
        let beeWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = beeWorkerSpy

        // When
        let request = ManageTag.CreateTag.Request(tagFormFields: ManageTag.TagFormFields(id: 1, name: "Test", color: "#FFFFFF", createdDate: "20388371929", description: "test"))
        sut.createTag(request: request)
        
        // Then
        XCTAssert(beeWorkerSpy.createTagCalled, "createTag() should ask Beeworker to crate the new tag")
        XCTAssert(manageTagPresentationLogicSpy.presentCreateTagCalled, "createTag() should ask presenter to format the created tag")
    }
    
    // Update tag
    func testUpdateTagShouldAskBeeWorkerToUpdateTheExistingTagAndPresenterToFormatIt(){
       // Given
        let manageTagPresentationLogicSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogicSpy
        let beeWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = beeWorkerSpy
        sut.tagsToChoose = Seeds.Tags.tags
        
        // When
        let request = ManageTag.UpdateTag.Request(tagFormFields: ManageTag.TagFormFields(id: 1, name: "", color: "", createdDate: "20388371929", description: ""))
        sut.updateTag(request: request)
        
        // Then
        XCTAssert(beeWorkerSpy.updateTagCalled, "UpdateTag() should ask Beeworker to update the existing tag")
        XCTAssert(manageTagPresentationLogicSpy.presentUpdatedTagCalled, "UpdateTag() should ask presenter to format the updated tag")
    }
    
    // Delete tag
    func testDeleteTagShouldAskBeeWorkerToDeleteTheExistingTagaAndPresenterToFormatIt() {
        // Given
        let manageTagPresentationLogicSpy = ManageTagPresentationLogicSpy()
        sut.presenter = manageTagPresentationLogicSpy
        let beeWorkerSpy = BeeWorkerSpy(BeeDB: BeeMemDB())
        sut.beeWorker = beeWorkerSpy

        // When
        let request = ManageTag.DeleteTag.Request(tagId: 0)
        sut.deleteTag(request: request)

        // Then
        XCTAssert(beeWorkerSpy.deleteTagCalled, "deleteTag() should ask Beeworker to delete the existing tag")
        XCTAssert(manageTagPresentationLogicSpy.presentDeletedTagCalled, "deleteTag() should ask presenter to format the deleted tag")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
