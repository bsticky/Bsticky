//
//  ListStickiesViewControllerTests.swift
//  bStickyTests
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class ListStickiesViewControllerTests: XCTestCase {
    
    // MARK: - Subject under test
    
    var sut: ListStickiesViewController!
    var window: UIWindow!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupListStickiesViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: - Test setup
    func setupListStickiesViewController() {
        sut = ListStickiesViewController()
        sut.loadViewIfNeeded()
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Spy classes
    
    class ListStickiesBusinessLogicSpy: ListStickiesBusinessLogic {
        
        var stickies: [Sticky]?
        
        // MARK: Method call expectations
        var fetchStickiesCalled = false
        
        func fetchStickies(request: ListStickies.FetchStickies.Request) {
            fetchStickiesCalled = true
        }
    }
    
    class CollectionViewSpy: UICollectionView {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            super.init(frame: .zero, collectionViewLayout: layout)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: Spied methods
        
        override func reloadData() {
            reloadDataCalled = true
        }
    }
    
    // MARK: - Tests
    
    func testShouldFetchStickiesWhenViewDidAppear() {
        // Given
        let listStickiesBusinessLogicSpy = ListStickiesBusinessLogicSpy()
        sut.interactor = listStickiesBusinessLogicSpy
        loadView()
        
        // When
        sut.viewDidAppear(true)
        
        // Then
        XCTAssert(listStickiesBusinessLogicSpy.fetchStickiesCalled, "Should fetch stickies after view will appear")
    }
    
    func testShouldDisplayFetchedStickies() {
        // Given
        let collectionViewSpy = CollectionViewSpy()

        sut.listStickiesView.collectionView = collectionViewSpy
        
        // When
        let viewModel = ListStickies.FetchStickies.ViewModel(tagName: "One", tagColor: "#FFFFFF", stickies: [Sticky(id: 0, tagId: 0, tagColor: "#FFFFFF", contentsType: ContentsType.Text, text: "Test Text", filePath: "", contentsAttributesId: 0, createdDate: 19891989, updatedDate: 19891989)])
        sut.displayFetchedStickies(viewModel: viewModel)
        
        // Then
        XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying fetched stickies should reload teh collection view")
    }
    
    func theNumberOfSectionsInCollectionViewShouldBeOne() {
        // Given
        let collectionView = sut.listStickiesView.collectionView
        
        // When
        let numberOfSections = sut.numberOfSections(in: collectionView)
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of collection view sections should be 1")
    }
    
    func testNumberOfRowsShouldEqualNumberOfStickiesToDisplay() {
        // Given
        let collectionView = sut.listStickiesView.collectionView
        let testDisplayedStickes = [Sticky(id: 0, tagId: 0, tagColor: "#FFFFFF", contentsType: ContentsType.Text, text: "Test Text", filePath: "", contentsAttributesId: 0, createdDate: 19891989, updatedDate: 19891989)]
        sut.displayedStickies = testDisplayedStickes
        
        // When
        let numberOfRows = sut.listStickiesView.collectionView.numberOfItems(inSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, testDisplayedStickes.count, "The number of collection view rows should equal the number of stickies to display")
    }
    
    /*
    func testShouldConfigureCollectionViewCellToDisplayStickies() {
        // Given
        let viewModel = ListStickies.FetchStickies.ViewModel(tagName: "One", tagColor: "#FFFFFF", stickies: [Sticky(id: 0, tagId: 0, tagColor: "#FFFFFF", contentsType: ContentsType.Text, text: "Test Text", filePath: "", contentsAttributesId: 0, createdDate: 19891989, updatedDate: 19891989)])
        sut.displayFetchedStickies(viewModel: viewModel)
        sut.listStickiesView.collectionView.layoutIfNeeded()

        // When
        let textCell = sut.listStickiesView.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! StickyCell
        //let imageCell = sut.listStickiesView.collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! StickyCell
        
        // Then
        XCTAssertEqual(textCell.backgroundColor?.toHex, "FFFFFF")
        XCTAssertEqual(textCell.text, "Test Text")
        
        //XCTAssertEqual(imageCell.backgroundColor?.toHex, "222222")
        //XCTAssertNotNil(imageCell.image)

    }
    */
}
