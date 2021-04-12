//
//  StickyWorkerTests.swift
//  bStickyTests
//
//  Created by mima on 18/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

class BeeWorkerTests: XCTestCase {
    
    var sut: BeeWorker!
    static var testTags: [Tag]!
    static var testStickies: [Sticky]!
    
    override func setUp() {
        super.setUp()
        setupBeeWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupBeeWorker() {
        sut = BeeWorker(BeeDB: BeeMemDBSpy())
        
        BeeWorkerTests.testTags = [Seeds.Tags.tags[0], Seeds.Tags.tags[1]]
        BeeWorkerTests.testStickies = [Seeds.Stickies.textSticky, Seeds.Stickies.imageSticky]
    }
    
    class BeeMemDBSpy: BeeMemDB {
        // Method call expectations
        var fetchTagsCalled = false
        var updateTagCalled = false
        
        
        var createStickyCalled = false

        // Spied methods
        override func fetchTags(completionHandler: @escaping (() throws -> [Tag]) -> Void) {
            fetchTagsCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                completionHandler { () -> [Tag] in
                    return BeeWorkerTests.testTags
                }
            }
        }
        
        override func updateTag(tagToUpdate: Tag, completionHandler: @escaping (() throws -> Tag?) -> Void) {
            updateTagCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                completionHandler { () -> Tag in
                    return tagToUpdate
                }
            }
        }

        override func createSticky(stickyToCreate: Sticky, completionHandler: @escaping (() throws -> Sticky?) -> Void) {
            createStickyCalled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                completionHandler { () -> Sticky in
                    return BeeWorkerTests.testStickies.first!
                }
            }
        }
    }
    
    // Tests
    func testFetchTagsShouldReturnListofTags() {
        // Given
        let beeMemDBSpy = sut.beeDB as! BeeMemDBSpy
        
        // When
        var fetchedTags = [Tag]()
        let expect = expectation(description: "wait for fetchTags() to return")
        sut.fetchTags { (tags) in
            fetchedTags = tags
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.1)
        
        // Then
        XCTAssert(beeMemDBSpy.fetchTagsCalled, "Calling fetchTags() should ask the database for a list of tags")
        XCTAssertEqual(fetchedTags.count, BeeWorkerTests.testTags.count, "fetchTags() should return a list of tags")
        for tag in fetchedTags {
            XCTAssert(BeeWorkerTests.testTags.contains(tag), "Fetched tags should match the tags in the database")
        }
    }
    
    func testUpdateTagShouldReturnTheUpdatedTag() {
        // Given
        let beeMemDBSpy = sut.beeDB as! BeeMemDBSpy
        var tagToUpdate = BeeWorkerTests.testTags.first!
        let name = "UpdateName"
        tagToUpdate.name = name
        
        // When
        var updatedTag: Tag?
        let expect = expectation(description: "Wait for updateTag() to return")
        sut.updatedTag(tagToUpdate: tagToUpdate) { (tag) in
            updatedTag = tag
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.1)
        
        // Then
        XCTAssert(beeMemDBSpy.updateTagCalled, "Calling updatag() should ask the database to update the exisiting tag")
        XCTAssertEqual(updatedTag, tagToUpdate, "updateTag() should update the existing tag")
    }
    
    
    func testCreateStickyShouldReturnTheCreatedSticky() {
        // Given
        let stickyMemDBSpy = sut.beeDB as! BeeMemDBSpy
        let stickyToCreate = BeeWorkerTests.testStickies.first!
        
        // When
        var createdSticky: Sticky?
        let expect = expectation(description: "Wait for createdSticky() to return")
        sut.createSticky(stickyToCreate: stickyToCreate) { (sticky) in
            createdSticky = sticky
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.1, handler: nil)
        
        // Then
        XCTAssert(stickyMemDBSpy.createStickyCalled, "Calling creatSticky() should aks the database to create the new sticky")
        XCTAssertEqual(createdSticky, stickyToCreate, "createSticky() should create the new sticky")
    }
    


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
