//
//  ManageTagViewControllerTests.swift
//  bStickyTests
//
//  Created by mima on 06/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

struct TestDisplaySaveTagFailure {
    static var presentViewControllerAnimatedCompletionCalled = false
    static var viewControllerToPrssent: UIViewController?
}

extension ManageTagViewController {
    override open func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        TestDisplaySaveTagFailure.presentViewControllerAnimatedCompletionCalled = true
        TestDisplaySaveTagFailure.viewControllerToPrssent = vc
    }
}

class ManageTagViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ManageTagViewController!
    var window: UIWindow!
    
    // MARK: -Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupManageTagViewController()
    }
    
    override func tearDown() {
        window = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupManageTagViewController() {
        sut = ManageTagViewController()
        sut.loadViewIfNeeded()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Interactor spy
    
    class ManageTagBusinessLogicSpy: ManageTagBuisinessLogic {

        // Method call expectations
        var showTagToEditCalled = false
        var showTagsToChooseCalled = false
        var createTagCalled = false
        var updateTagCalled = false
        var deleteTagCalled = false
        
        // Argument expectations
        var editTagRequest: ManageTag.EditTag.Request!
        var updateTagRequest: ManageTag.UpdateTag.Request!

        // Spied variables
        var chosenTagId: Int?
        var tagsToChoose: [Tag]?
        var chosenTagButtonPosition: Int?
        
        // Spied methods
        func showTagToEdit(request: ManageTag.EditTag.Request) {
            showTagToEditCalled = true
            self.editTagRequest = request
        }
        
        func showTagsToChoose(request: ManageTag.ChooseTag.Request) {
            showTagsToChooseCalled = true
        }
        
        func createTag(request: ManageTag.CreateTag.Request) {
            createTagCalled = true
        }
        
        func updateTag(request: ManageTag.UpdateTag.Request) {
            updateTagCalled = true
            self.updateTagRequest = request
        }
        
        func deleteTag(request: ManageTag.DeleteTag.Request) {
            deleteTagCalled = true
        }
    }
    
    // MARK: - Tableview spy
    
    class TableViewSpy: ChooseTagView {
        
        // Method call expectations
        var reloadDataCalled = false
        
        // Spied methods
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    
    // MARK: - Router spy
    
    class ManageTagRouterSpy: ManageTagRouter {
        // Method call expectations
        var routeToStartBeeCalled = false
        
        // Spied methods
        override func routeToStartBee() {
            routeToStartBeeCalled = true
        }
    }
    
    // MARK: Edit tag
    
    func testShouldCallShowTagToEditWhenViewIsLoaded() {
        // Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        
        // When
        loadView()
        
        // Then
        XCTAssert(manageTagBusinessLogicSpy.showTagToEditCalled, "Show tag when the view is loaded")
        
    }
    
    func testShouldDisplayTagToEdit() {
        //Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        loadView()
        
        // When
        let viewModel = ManageTag.EditTag.ViewModel(tagFormFields: ManageTag.TagFormFields(id: 1, name: "TestTag", color: "#FF1D00", createdDate: "TestDate", description: "TestDescription"))
        sut.displayTagToEdit(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.manageTagView.tagView.editTagView.nameView.text, "TestTag")
        XCTAssertEqual(sut.manageTagView.tagView.editTagView.dateView.text, "TestDate")
        XCTAssertEqual(sut.manageTagView.tagView.editTagView.descriptionView.text, "TestDescription")
    }
    

    // MARK: Choose tag
    
    func testShouldCallShowTagsToChooseWhenViewIsLoaded() {
        // Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        
        // When
        loadView()
        
        // Then
        XCTAssert(manageTagBusinessLogicSpy.showTagsToChooseCalled, "Show tags when the view is loaded")
        
    }
    
    func testShouldDisplayTagsToChoose() {
        // Given
        let tableViewSpy = TableViewSpy()
        sut.manageTagView.chooseTagView = tableViewSpy
        
        // When
        let displayedTag = ManageTag.ChooseTag.ViewModel.DisplayedTag(id: 5050, name: "TagName", color: "#000000")
        let displayedTags = [displayedTag]
        let viewModel = ManageTag.ChooseTag.ViewModel(displayedTags: displayedTags)
        sut.displayTagsToChoose(viewModel: viewModel)
        
        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying tags to chose should reload the table view")
    }
    
    func testNumberOfRowsInAnySectionShouldEqualNumberOfTagsToDisplay() {
        // Given
        let tableView = sut.manageTagView.chooseTagView
        let testDisplayedTags = [ManageTag.ChooseTag.ViewModel.DisplayedTag(id: 5022, name: "TEST", color: "#FFFFFF")]
        sut.displayedTags = testDisplayedTags
        
        // When
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, testDisplayedTags.count, "The number of table view rows should equal the number of tags to display")
    }
    
    func testShouldConfigureChooseTagViewCellToDisplayTag() {
        // Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        loadView()
        let tableView = sut.manageTagView.chooseTagView

        // When
        let displayedTag = ManageTag.ChooseTag.ViewModel.DisplayedTag(id: 5023, name: "TEST", color: "#FFFFFF")
        let viewModel = ManageTag.ChooseTag.ViewModel(displayedTags: [displayedTag])
        sut.displayTagsToChoose(viewModel: viewModel)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! TagCell

        // Then
        XCTAssertEqual(cell.id, 5023)
        XCTAssertEqual(cell.colorView.backgroundColor?.toHex, "FFFFFF")
        XCTAssertEqual(cell.titleLabel.text, "TEST")
    }

    // MARK: Create tag
    
    func testDoneButtonTappedShouldCreateTag() {
        // Given
        let manageTagBuisinessLogicSpy = ManageTagBusinessLogicSpy()
        manageTagBuisinessLogicSpy.chosenTagId = 0
        sut.interactor = manageTagBuisinessLogicSpy
        loadView()

        // When
        let tagFormFields = ManageTag.TagFormFields(id: 0, name: "", color: "", createdDate: "", description: "")
        sut.doneButtonTapped(self, tagFormFields: tagFormFields)
        
        // Then
        XCTAssert(manageTagBuisinessLogicSpy.createTagCalled, "It should create a new tag when the user taps the Done button")
    }
    
    func testSuccessfullyCreatedTagShouldRouteBackToStartBeeScene() {
        // Given
        loadView()
        let manageTagRouterSpy = ManageTagRouterSpy()
        sut.router = manageTagRouterSpy
        
        // When
        let viewModel = ManageTag.CreateTag.ViewModel(tag: Seeds.Tags.tags[0])
        sut.displayCreatedTag(viewModel: viewModel)
        
        // Then
        XCTAssert(manageTagRouterSpy.routeToStartBeeCalled, "Displaying a successfully created tag should navigate back to the StartBee scene")
    }
    
    func testCreateTagFailureShouldShowAlert() {
        // Given
        loadView()
        
        // When
        let viewModel = ManageTag.CreateTag.ViewModel(tag: nil)
        sut.displayCreatedTag(viewModel: viewModel)
        let alertController = TestDisplaySaveTagFailure.viewControllerToPrssent as! UIAlertController
        
        // Then
        XCTAssert(TestDisplaySaveTagFailure.presentViewControllerAnimatedCompletionCalled, "Displaying create tag failure should show an alert")
        XCTAssertEqual(alertController.title, "Failed to create tag")
        XCTAssertEqual(alertController.message, "Please correct your tag and submit again.\n If you still encounter problem, please report a bug.")
    }
    
    // MARK: Update tag
    
    func testSaveButtonTappedShouldUpdateTag() {
        // Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        loadView()

        // When
        let  tagFormFields = ManageTag.TagFormFields(id: 0, name: "", color: "", createdDate: "", description: "")
        sut.saveButtonTapped(self, tagFormFields: tagFormFields)
        
        // Then
        XCTAssert(manageTagBusinessLogicSpy.updateTagCalled, "It should update an existing tag when the user taps the save button")
    }
    
    func testSuccessfullyUpdatedTagShouldRouteBackToStartBeeScene() {
        // Given
        loadView()
        let manageTagRouterSpy = ManageTagRouterSpy()
        sut.router = manageTagRouterSpy
        
        // When
        let viewModel = ManageTag.UpdateTag.ViewModel(tag: Seeds.Tags.tags[0])
        sut.displayUpdatedTag(viewModel: viewModel)
        
        // Then
        XCTAssert(manageTagRouterSpy.routeToStartBeeCalled, "Displaying a sucessfully updated tag should back to the StartBee scene")
    }
    
    func testUpdateTagFailureShouldShowAlert() {
        // Given
        loadView()
        
        // When
        let viewModel = ManageTag.UpdateTag.ViewModel(tag: nil)
        sut.displayUpdatedTag(viewModel: viewModel)

        // Then
        let alertController = TestDisplaySaveTagFailure.viewControllerToPrssent as! UIAlertController
        XCTAssert(TestDisplaySaveTagFailure.presentViewControllerAnimatedCompletionCalled, "Displaying create tag failure should show an alert")
        XCTAssertEqual(alertController.title, "Failed to update tag")
        XCTAssertEqual(alertController.message, "Please correct your tag and submit again.\n If you still encounter problems, please report a bug.")
    }
    
    // MARK: Delete tag

    func testDeleteButtonTappedSHouldShowWarningAlert() {
        // Given
        loadView()
        
        // When
        sut.deleteButtonTapped(self, tagId: 0)
        let alertControlelr = TestDisplaySaveTagFailure.viewControllerToPrssent as! UIAlertController
        
        // Then
        XCTAssert(TestDisplaySaveTagFailure.presentViewControllerAnimatedCompletionCalled, "Delete tag buttton tapped should show warning alert.")
        XCTAssertEqual(alertControlelr.title, "Delete tag")
        XCTAssertEqual(alertControlelr.message, "Are you sure you want to delete this tag?\nThis action cannot be undone.")
    }
    
    func testdeleteTagFunctionShouldDeleteTag() {
        // Given
        let manageTagBusinessLogicSpy = ManageTagBusinessLogicSpy()
        sut.interactor = manageTagBusinessLogicSpy
        loadView()
        
        // When
        sut.deleteTag(tagId: 0)
        
        // Then
        XCTAssert(manageTagBusinessLogicSpy.deleteTagCalled, "It should delete an existing tag when the user taps the yes button")
    }
    
    func testSuccessfullyDeletedTagShouldReloadTableView() {
        // Given
        loadView()
        let tableViewSpy = TableViewSpy()
        sut.manageTagView.chooseTagView = tableViewSpy

        // When
        let displayedTag = ManageTag.ChooseTag.ViewModel.DisplayedTag(id: 5050, name: "TagName", color: "#000000")
        sut.displayedTags = [displayedTag]
        sut.displayDeletedTag(viewModel: ManageTag.DeleteTag.VieWModel(tagId: 5050))

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying tags to chose should reload the table view")
    }
    
    func testDeleteTagFailureShouldShowAlert() {
        // Given
        loadView()
        
        // When
        let viewModel = ManageTag.DeleteTag.VieWModel(tagId: nil)
        sut.displayDeletedTag(viewModel: viewModel)
        let alertController = TestDisplaySaveTagFailure.viewControllerToPrssent as! UIAlertController
        
        // Then
        XCTAssert(TestDisplaySaveTagFailure.presentViewControllerAnimatedCompletionCalled,
                  "Displaying delete tag failure should show an alert")
        XCTAssertEqual(alertController.title, "Failed to delete tag")
        XCTAssertEqual(alertController.message, "Please try again. If you still encounter problems, please report a bug.")
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
