//
//  StickySqliteHelperTests.swift
//  bStickyTests
//
//  Created by mima on 26/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest
import SQLite3

class BeeSqliteHelperTests: XCTestCase {
    // Subject under test
    var sut: BeeSqliteHelper!
    
    override func setUp() {
        super.setUp()
        setupBeeSqliteHelper()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupBeeSqliteHelper() {
        // test database on memory
        sut = BeeSqliteHelper(databaseURL: ":memory:")
    }
    
    // Tests
    func testCreateTable() {
        // Given
        var exist = false

        // When
        do {
            try sut.createTable(sql: BeeSqls.CreateTagTable)
        } catch {
            print("Error | \(sut.errorMessage)")
        }
        exist = checkIfTableIsExist()
        
        // Then
        XCTAssert(exist, "Creating Table should creat the table")

    }
    
    func testPrepareStatement() {
        // Given

    }
    
    // Test helper functions
    func checkIfTableIsExist() -> Bool {
        var count = 0
        let testSql = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='Tag';"

        guard let statement = try? sut.prepareStatement(sql: testSql)
            else { fatalError("ERROR \(sut.errorMessage)") }
        
        defer { sqlite3_finalize(statement) }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            count = Int(sqlite3_column_int(statement, 0))
        }
        
        return (count == 1) ? true : false
    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
