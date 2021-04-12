//
//  ManageTagPresenterTests.swift
//  bStickyTests
//
//  Created by mima on 09/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class ManageTagPresenterTests: XCTestCase {
    
    // MARK: - Subject under test
    var sut: ManageTagPresenter!
    
    
    // MARK: - Test lifecycle
    override func setUp() {
        super.setUp()
        setupManageTagPresenter()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func setupManageTagPresenter() {
        sut = ManageTagPresenter()
    }
    
    
    // MARK: - Viewcontroller spy
    class ManageTagDisplayLogicSpy: ManageTagDisplayLogic {
        

        // Method call expectations
        var displayTagToEditCalled = false
        var displayTagsToChooseCalled = false
        var displayCreatedtagCalled = false
        var displayUpdatedtagCalled = false
        var displayDeletedtagCalled = false
        
        // Argument expectations
        var editTagVieWModel: ManageTag.EditTag.ViewModel!
        var chooseTagVieWModel: ManageTag.ChooseTag.ViewModel!
        var createTagViewModel: ManageTag.CreateTag.ViewModel!
        var updateTagViewModel: ManageTag.UpdateTag.ViewModel!
        var deleteTagViewModel: ManageTag.DeleteTag.VieWModel!
        
        
        func displayTagToEdit(viewModel: ManageTag.EditTag.ViewModel) {
            displayTagToEditCalled = true
            self.editTagVieWModel = viewModel
        }
        
        func displayTagsToChoose(viewModel: ManageTag.ChooseTag.ViewModel) {
            displayTagsToChooseCalled = true
            self.chooseTagVieWModel = viewModel
        }
        
        func displayCreatedTag(viewModel: ManageTag.CreateTag.ViewModel) {
            displayCreatedtagCalled = true
            self.createTagViewModel = viewModel
        }
        
        func displayUpdatedTag(viewModel: ManageTag.UpdateTag.ViewModel) {
            displayUpdatedtagCalled = true
            self.updateTagViewModel = viewModel
        }
        
        func displayDeletedTag(viewModel: ManageTag.DeleteTag.VieWModel) {
            displayDeletedtagCalled = true
            self.deleteTagViewModel = viewModel
        }
    }
    
    // MARK: - Tests
    
    // Edit tag
    func testPresentTagToEditShouldAskViewControllerToDisplayTag() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let tag = Seeds.Tags.tags[0]
        let response = ManageTag.EditTag.Response(tag: tag)
        sut.presentTagToEdit(response: response)
        
        // Then
        XCTAssert(manageTagDisplayLogicSpy.displayTagToEditCalled, "Presenting tag to edit should ask view controller to display it")
    }
    
    func testPresentTagToEditShouldFormatTheExisitingTagForDisplayUsingSpy() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let tag = Seeds.Tags.tags[0]
        let response = ManageTag.EditTag.Response(tag: tag)
        sut.presentTagToEdit(response: response)
        
        // Then
        let formattedDate = "Created on " + BeeDateFormatter.convertDate(since1970: tag.createdDate)
        
        XCTAssert(manageTagDisplayLogicSpy.displayTagToEditCalled, "Presenting the tag to edit should ask view controller to display it")
        XCTAssertEqual(manageTagDisplayLogicSpy.editTagVieWModel.tagFormFields.id, tag.id, "Presenting the tag to edit should foramt the existing tag")
        XCTAssertEqual(manageTagDisplayLogicSpy.editTagVieWModel.tagFormFields.color, tag.color, "Presenting the tag to edit should foramt the existing tag")
        XCTAssertEqual(manageTagDisplayLogicSpy.editTagVieWModel.tagFormFields.name, tag.name, "Presenting the tag to edit should foramt the existing tag")
        XCTAssertEqual(manageTagDisplayLogicSpy.editTagVieWModel.tagFormFields.description, tag.description, "Presenting the tag to edit should foramt the existing tag")
        XCTAssertEqual(manageTagDisplayLogicSpy.editTagVieWModel.tagFormFields.createdDate, formattedDate, "Presenting the tag to edit should foramt the existing tag")
    }
    
    // Choose tag
    func testPresentTagsToChooseShouldAskViewControllerToDisplayTags() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let tags = [Seeds.Tags.tags[0]]
        let response = ManageTag.ChooseTag.Response(tags: tags)
        sut.presentTagsToChoose(response: response)

        // Then
        XCTAssert(manageTagDisplayLogicSpy.displayTagsToChooseCalled, "Presenting tags to choose should ask view controller to display it")
    }
    

    // Create tag
    func testPresentCreatedTagShouldAskViewControllerToDisplayTheCreatedTag() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let tag = Seeds.Tags.tags[0]
        let response = ManageTag.CreateTag.Response(tag: tag)
        sut.presentCreatedTag(response: response)
        
        // Then
        XCTAssert(manageTagDisplayLogicSpy.displayCreatedtagCalled, "Presenting the created tag should ask view controller to display it")
        XCTAssertNotNil(manageTagDisplayLogicSpy.createTagViewModel.tag, "Presenting the created tag should succed")
    }
    
    // Update tag
    func testPresentUpdatedTagShouldAskViewControllerToDisplayTheUpdatedTag() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let tag = Seeds.Tags.tags[0]
        let response = ManageTag.UpdateTag.Response(tag: tag)
        sut.presentUpdatedTag(response: response)
        
        // Then
        XCTAssert(manageTagDisplayLogicSpy.displayUpdatedtagCalled, "Presenting the updated tag should ask view controller to display it")
        XCTAssertNotNil(manageTagDisplayLogicSpy.updateTagViewModel.tag, "Presenting the updated tag should succed")
    }
    
    // Delete tag
    func testPresentDeletedTagShouldAskViewControllerToDisplayTheDeletedTag() {
        // Given
        let manageTagDisplayLogicSpy = ManageTagDisplayLogicSpy()
        sut.viewController = manageTagDisplayLogicSpy
        
        // When
        let response = ManageTag.DeleteTag.Response(tagId: 1)
        sut.presentDeletedTag(response: response)

        // Then
        XCTAssert(manageTagDisplayLogicSpy.displayDeletedtagCalled, "Presenting the deleted tag should ask view controller to display it")
        XCTAssertNotNil(manageTagDisplayLogicSpy.deleteTagViewModel.tagId, "Presenting the deleted tag should succed")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
