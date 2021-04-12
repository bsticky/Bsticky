//
//  StickySqliteHelper.swift
//  bSticky
//
//  Created by mima on 26/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import SQLite3
import Foundation

protocol BeeSqliteHelperProtocol {
    func createTable(table: String) throws
    func fetchTag(tagId: Int)  -> Tag?
    func fetchTags() throws -> [Tag]
    func updateTag(tag: Tag) throws -> Tag?
    func fetchManagedSticky(stickyId: Int) throws -> ManagedSticky?
    func fetchStickies(offset: Int, limit: Int) throws -> [Sticky]
}

class BeeSqliteHelper: BeeSqliteHelperProtocol {

    private var db: OpaquePointer?
    
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(db) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided form database"
        }
    }
    
    // MARK: - Init
    
    init(databaseURL: String?) {
        var db: OpaquePointer?
        
        guard let databaseURL = databaseURL else {
            fatalError("Error initializing database | \(errorMessage) ")
        }
        
        // Opening a connection
        if sqlite3_open(databaseURL, &db) == SQLITE_OK {
            self.db = db
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                    db = nil
                }
            }
            fatalError("Error initilizing database | \(errorMessage)")
        }
        
        // Enable foreign keys
        do {
            try executeQuery(sql: BeeSqls.ForeignKeysOn)
        } catch {
            fatalError("Can not enable database foreign keys | \(errorMessage))")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    

    
    // MARK: - Function <Tag>
    
    // MARK: Create tag
    
    func insertTag(tag: Tag) throws -> Tag? {
        let statement = try prepareStatement(sql: BeeSqls.InsertTag.rawValue)

        defer { sqlite3_finalize(statement) }
        
        let name: NSString = tag.name as NSString
        let color: NSString = tag.color as NSString
        let position = Int32(tag.position)
        let activated = Int32(1)
        let createdDate = Int32(Date().timeIntervalSince1970)
        let description: NSString = tag.description! as NSString

        guard sqlite3_bind_text(statement, 1, name.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, 2, color.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(statement, 3, position) == SQLITE_OK &&
            sqlite3_bind_int(statement, 4, activated) == SQLITE_OK &&
            sqlite3_bind_int(statement, 5, createdDate) == SQLITE_OK &&
            sqlite3_bind_text(statement, 6, description.utf8String, -1, nil) == SQLITE_OK
            else {
                throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        
        // Deactivate other tag or tgas if it set on the same position
        let tagId = sqlite3_last_insert_rowid(db)
        let deactivateStatement = try deactivateTags(tagId: Int32(tagId), position: position)
        
        defer { sqlite3_finalize(deactivateStatement)}
        
        guard sqlite3_step(deactivateStatement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }

        return tag
    }
    
    // MARK: Fetch tags
    
    func fetchTags() throws -> [Tag] {
        var tags: [Tag] = []
        
        let statement = try prepareStatement(sql: BeeSqls.FetchTags.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            let name = String(cString: sqlite3_column_text(statement, 1))
            let color = String(cString: sqlite3_column_text(statement, 2))
            let position = sqlite3_column_int(statement, 3)
            let activated = sqlite3_column_int(statement, 4)
            let createdDate = sqlite3_column_double(statement, 5)
            let description = String(cString: sqlite3_column_text(statement, 6))
            
            let boolactivated: Bool = ( activated == 1 ? true: false)
            
            tags.append(Tag(id: Int(id), name: name, color: color, position: Int(position), activated: boolactivated, createdDate: Int(createdDate), description: description))
        }
        return tags
    }
    
    func fetchTag(tagId: Int) -> Tag? {
        return Tag(id: tagId, name: "", color: "", position: 0, activated: false, createdDate: 0, description: "")
    }

    // MARK: Update tag
    
    func updateTag(tag: Tag) throws -> Tag? {
        let statement = try prepareStatement(sql: BeeSqls.UpdateTag.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        let name: NSString = tag.name as NSString
        let color: NSString = tag.color as NSString
        let activated = tag.activated == true ? 1 : 0
        let description: NSString = tag.description! as NSString
        
        guard sqlite3_bind_text(statement, 1, name.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, 2, color.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(statement, 3, Int32(tag.position)) == SQLITE_OK &&
            sqlite3_bind_int(statement, 4, Int32(activated)) == SQLITE_OK &&
            sqlite3_bind_text(statement, 5, description.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(statement, 6, Int32(tag.id)) == SQLITE_OK
            else {
                throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        
        // Deactivate other tag or tgas if it set on the same position
        let deactivateStatement = try deactivateTags(tagId: Int32(tag.id), position: Int32(tag.position))
        
        defer { sqlite3_finalize(deactivateStatement)}
        
        guard sqlite3_step(deactivateStatement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        
        return tag
    }
    
    // MARK: Delete tag
    
    func deleteTag(tagId: Int) throws -> Int? {
        let statement = try prepareStatement(sql: BeeSqls.DeleteTag.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(tagId)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        return tagId
    }
    
    // MARK: - Sticky
    
    // MARK: Create sticky
    
    func insertSticky(sticky: Sticky) throws -> Sticky? {
        let statement = try prepareStatement(sql: BeeSqls.InsertSticky.rawValue)

        defer { sqlite3_finalize(statement) }
        
        let contentsType = Int32(sticky.contentsType.rawValue)
        let text: NSString = sticky.text as NSString
        let filePath: NSString = sticky.filePath as NSString

        guard sqlite3_bind_int(statement, 1, Int32(sticky.tagId)) == SQLITE_OK &&
            sqlite3_bind_int(statement, 2, contentsType) == SQLITE_OK &&
                sqlite3_bind_text(statement, 3, text.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(statement, 4, filePath.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_int(statement, 5, Int32(sticky.createdDate)) == SQLITE_OK &&
                sqlite3_bind_int(statement, 6, Int32(sticky.updatedDate)) == SQLITE_OK
        else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        return sticky
    }
    
    // MARK: Fetch sticky
    
    func fetchManagedSticky(stickyId: Int) throws -> ManagedSticky? {
        
        let statement = try prepareStatement(sql: BeeSqls.FetchSticky.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(stickyId)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }

        let id = Int(sqlite3_column_int(statement, 0))
        let tagId = Int(sqlite3_column_int(statement, 1))
        let contentsType = Int(sqlite3_column_int(statement, 2))
        let text = String(cString: sqlite3_column_text(statement, 3))
        let fileName = String(cString: sqlite3_column_text(statement, 4))
        let createdDate = Int(sqlite3_column_int(statement, 5))
        let updatedDate = Int(sqlite3_column_int(statement, 6))
        let tagColor = String(cString: sqlite3_column_text(statement, 7))
        let tagname = String(cString: sqlite3_column_text(statement, 8))
        
        let managedSticky = ManagedSticky(id: id, tagColor: tagColor, tagName: tagname, contentsType: ContentsType(rawValue: contentsType)!, text: text, fileName: fileName, createdDate: createdDate, updatedDate: updatedDate)
        
        return managedSticky
    }
    
    // MARK: Fetch stickies
    
    func fetchStickies(offset: Int, limit: Int) throws -> [Sticky] {
        var stickies: [Sticky] = []
        
        let statement = try prepareStatement(sql: BeeSqls.FetchStickiesFromOffset.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(offset)) == SQLITE_OK &&
                sqlite3_bind_int(statement, 2, Int32(limit)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(statement, 0))
            let tagId = Int(sqlite3_column_int(statement, 1))
            let contentsType = Int(sqlite3_column_int(statement, 2))
            let text = String(cString: sqlite3_column_text(statement, 3))
            let filePath = String(cString: sqlite3_column_text(statement, 4))
            let createdDate = Int(sqlite3_column_int(statement, 5))
            let updatedDate = Int(sqlite3_column_int(statement, 6))
            let tagColor = String(cString: sqlite3_column_text(statement, 7))
            
            stickies.append(Sticky(id: id,
                                   tagId: tagId,
                                   tagColor: tagColor,
                                   contentsType: ContentsType.init(rawValue: contentsType)!,
                                   text: text,
                                   filePath: filePath,
                                   createdDate: createdDate,
                                   updatedDate: updatedDate))
        }
        return stickies
    }
    
    func fetchStickiesWithTagId(tagId: Int, offset: Int, limit: Int) throws -> [Sticky] {
        var stickies: [Sticky] = []
        
        let statement = try prepareStatement(sql: BeeSqls.FetchStickiesWithTagId.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(tagId)) == SQLITE_OK
                && sqlite3_bind_int(statement, 2, Int32(offset)) == SQLITE_OK
                && sqlite3_bind_int(statement, 3, Int32(limit)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let id = Int(sqlite3_column_int(statement, 0))
            let tagId = Int(sqlite3_column_int(statement, 1))
            let contentsType = Int(sqlite3_column_int(statement, 2))
            let text = String(cString: sqlite3_column_text(statement, 3))
            let filePath = String(cString: sqlite3_column_text(statement, 4))
            let createdDate = Int(sqlite3_column_int(statement, 5))
            let updatedDate = Int(sqlite3_column_int(statement, 6))
            let tagColor = String(cString: sqlite3_column_text(statement, 7))

            stickies.append(Sticky(id: id,
                                   tagId: tagId,
                                   tagColor: tagColor,
                                   contentsType: ContentsType.init(rawValue: contentsType)!,
                                   text: text,
                                   filePath: filePath,
                                   createdDate: createdDate,
                                   updatedDate: updatedDate))
        }
        return stickies
    }
    
    func fetchAdjacentSticky(updatedDate: Int, isNext: Bool) throws -> ManagedSticky? {
        var query: String
        
        if isNext {
            query = BeeSqls.FetchNextSticky.rawValue
        } else {
            query = BeeSqls.FetchPreviousSticky.rawValue
        }
        
        let statement = try prepareStatement(sql: query)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(updatedDate)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            print(errorMessage)
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }

        let id = Int(sqlite3_column_int(statement, 0))
        let tagId = Int(sqlite3_column_int(statement, 1))
        let contentsType = Int(sqlite3_column_int(statement, 2))
        let text = String(cString: sqlite3_column_text(statement, 3))
        let fileName = String(cString: sqlite3_column_text(statement, 4))
        let createdDate = Int(sqlite3_column_int(statement, 5))
        let updatedDate = Int(sqlite3_column_int(statement, 6))
        let tagColor = String(cString: sqlite3_column_text(statement, 7))
        let tagname = String(cString: sqlite3_column_text(statement, 8))
        
        let managedSticky = ManagedSticky(id: id, tagColor: tagColor, tagName: tagname, contentsType: ContentsType(rawValue: contentsType)!, text: text, fileName: fileName, createdDate: createdDate, updatedDate: updatedDate)
        
        return managedSticky
    }
    
    func fetchAdjacentStickyWithinTag(updatedDate: Int, isNext: Bool, tagId: Int) throws -> ManagedSticky? {
        
        var query: String
        
        if isNext {
            query = BeeSqls.FetchNextStickyWithTag.rawValue
        } else {
            query = BeeSqls.FetchPreviousStickyWithTag.rawValue
        }
        
        let statement = try prepareStatement(sql: query)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(updatedDate)) == SQLITE_OK
                && sqlite3_bind_int(statement, 2, Int32(tagId)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_ROW else {
            print(errorMessage)
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }

        let id = Int(sqlite3_column_int(statement, 0))
        let tagId = Int(sqlite3_column_int(statement, 1))
        let contentsType = Int(sqlite3_column_int(statement, 2))
        let text = String(cString: sqlite3_column_text(statement, 3))
        let fileName = String(cString: sqlite3_column_text(statement, 4))
        let createdDate = Int(sqlite3_column_int(statement, 5))
        let updatedDate = Int(sqlite3_column_int(statement, 6))
        let tagColor = String(cString: sqlite3_column_text(statement, 7))
        let tagname = String(cString: sqlite3_column_text(statement, 8))
        
        let managedSticky = ManagedSticky(id: id, tagColor: tagColor, tagName: tagname, contentsType: ContentsType(rawValue: contentsType)!, text: text, fileName: fileName, createdDate: createdDate, updatedDate: updatedDate)
        
        return managedSticky
    }
    
    func deleteSticky(stickyId: Int) throws -> Int {
        let statement = try prepareStatement(sql: BeeSqls.DeleteSticky.rawValue)
        
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(stickyId)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
        return stickyId
    }

    // MARK: - Create table
    
    func createTable(table: String) throws {
        // Create tag table
        try executeQuery(sql: BeeSqls.CreateTagTable)
        
        // Insert default tag
        try insertDefaultTag()
        
        // Create sticky table
        try executeQuery(sql: BeeSqls.CreateStickyTable)
    }
    
    func insertDefaultTag() throws {
        let statement = try prepareStatement(sql: BeeSqls.InsertDefaultTag.rawValue)

        defer { sqlite3_finalize(statement) }
        
        let id = Int32(1)
        let name: NSString = "Untitled"
        let color: NSString = "#707070"
        let position = Int32(0)
        let activated = Int32(0)
        let createdDate = Int32(0)
        let description: NSString = ""

        guard sqlite3_bind_int(statement, 1, id) == SQLITE_OK &&
            sqlite3_bind_text(statement, 2, name.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(statement, 3, color.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(statement, 4, position) == SQLITE_OK &&
            sqlite3_bind_int(statement, 5, activated) == SQLITE_OK &&
            sqlite3_bind_int(statement, 6, createdDate) == SQLITE_OK &&
            sqlite3_bind_text(statement, 7, description.utf8String, -1, nil) == SQLITE_OK
            else {
                throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
    }

    // MARK: - Helper functions
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?

        guard sqlite3_prepare(db, sql, -1, &statement, nil) == SQLITE_OK else {

            // When insertTag() called but tag table does not exist.
            if sqlite3_errcode(db) == 1 && String(cString: sqlite3_errmsg(db)) == "no such table: tag" {
                try createTable(table: "tag")
                throw BeeSqliteHelperError.CreateTable(message: errorMessage)
            
            // When insertSticky() called but sticky table does not exist.
            } else if sqlite3_errcode(db) == 1 && String(cString: sqlite3_errmsg(db)) == "no such table: sticky"{
                try executeQuery(sql: BeeSqls.CreateStickyTable)
                throw BeeSqliteHelperError.CreateTable(message: errorMessage)
            
            // Error
            } else {
                throw BeeSqliteHelperError.Prepare(message: errorMessage)
            }
        }
        return statement
    }
    
    func executeQuery(sql: BeeSqls) throws {
        let statement = try prepareStatement(sql: sql.rawValue)
        
        defer {
            sqlite3_finalize(statement)
        }
        
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw BeeSqliteHelperError.Step(message: errorMessage)
        }
    }
    
    func deactivateTags(tagId: Int32, position: Int32) throws -> OpaquePointer? {
        let statement = try prepareStatement(sql: BeeSqls.DeactivateTags.rawValue)
        
        guard sqlite3_bind_int(statement, 1, tagId) == SQLITE_OK &&
            sqlite3_bind_int(statement, 2, position) == SQLITE_OK else {
                throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        return statement
    }
    
    func fetchTagName (tagId: Int32) throws -> String {
        var tagName: String?
        
        let statement = try prepareStatement(sql: BeeSqls.FetchTagName.rawValue)
    
        defer { sqlite3_finalize(statement) }
        
        guard sqlite3_bind_int(statement, 1, Int32(tagId)) == SQLITE_OK else {
            throw BeeSqliteHelperError.Bind(message: errorMessage)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            tagName = String(cString: sqlite3_column_text(statement, 0))
        }
        
        return tagName!
    }
}

enum BeeSqls: String {
    
    // MARK: Create table (tag, sticky)
    
    case ForeignKeysOn = """
    PRAGMA foreign_keys = ON;
    """
    
    case CreateTagTable = """
    CREATE TABLE IF NOT EXISTS tag(
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    name        CHAR(120) NOT NULL,
    color       CHAR(10)  NOT NULL,
    position    INTEGER  NOT NULL,
    activated   INTEGER  NOT NULL,
    created_date REAL  NOT NULL,
    description          CHAR(255) );
    """
    
    case CreateStickyTable = """
    CREATE TABLE IF NOT EXISTS sticky (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_id INTEGER DEFAULT 1,
    contents_type INTEGER NOT NULL,
    contents_text TEXT,
    contents_filepath TEXT,
    created_date REAL NOT NULL,
    updated_date REAL,
    FOREIGN KEY(tag_id) REFERENCES tag(id) ON UPDATE CASCADE ON DELETE SET DEFAULT
    );
    """
    
    case InsertDefaultTag = """
    INSERT INTO tag (id, name, color, position, activated, created_date, description)
    VALUES (?, ?, ?, ?, ?, ?, ?);
    """

    // MARK: CRUD - tag
    
    case FetchTags = """
    SELECT *
    FROM tag;
    """
    
    case FetchTag = """
    SELECT *
    FROM tag
    WHERE id = ?;
    """
    
    case FetchActivatedTags = """
    SELECT *
    FROM tag
    WHERE activated = 1;
    """
    
    case InsertTag = """
    INSERT INTO tag (name, color, position, activated, created_date, description)
    VALUES (?, ?, ?, ?, ?, ?);
    """
    
    case UpdateTag = """
    UPDATE tag
    SET name = ?,
    color = ?,
    position = ?,
    activated = ?,
    description = ?
    WHERE id = ?;
    """
    
    case DeactivateTags = """
    UPDATE tag
    SET position = 0,
    activated = 0
    WHERE id != ? AND position = ?;
    """
    
    case DeleteTag = """
    DELETE FROM tag
    WHERE id = ?;
    """
    
    // MARK: CRUD - sticky
    
    case InsertSticky = """
    INSERT INTO sticky (tag_id, contents_type, contents_text,
    contents_filepath, created_date, updated_date)
    VALUES (?, ?, ?, ?, ?, ?);
    """

    case FetchSticky = """
    SELECT sticky.*, tag.color, tag.name
    FROM sticky
    INNER JOIN tag ON tag.id = sticky.tag_id
    WHERE sticky.id = ?;
    """
  
    case FetchNextSticky = """
    SELECT sticky.*, tag.color, tag.name
    FROM sticky
    INNER JOIN tag ON tag.id = sticky.tag_id
    WHERE sticky.updated_date > ?
    ORDER BY sticky.updated_date
    LIMIT 1;
    """
    
    case FetchPreviousSticky = """
    SELECT sticky.*, tag.color, tag.name
    FROM sticky
    INNER JOIN tag on tag.id = sticky.tag_id
    WHERE updated_date < ?
    ORDER BY updated_date DESC
    LIMIT 1;
    """
    
    case FetchNextStickyWithTag = """
    SELECT sticky.*, tag.color, tag.name
    FROM sticky
    LEFT JOIN tag on tag.id = sticky.tag_id
    WHERE sticky.updated_date > ? AND sticky.tag_id = ?
    ORDER BY updated_date
    LIMIT 1;
    """
    
    case FetchPreviousStickyWithTag = """
    SELECT sticky.*, tag.color, tag.name
    FROM sticky
    LEFT JOIN tag on tag.id = sticky.tag_id
    WHERE sticky.updated_date < ? AND sticky.tag_id = ?
    ORDER BY updated_date DESC
    LIMIT 1;
    """
    
    case FetchStickiesFromOffset = """
    SELECT sticky.*, tag.color
    FROM sticky
    LEFT JOIN tag ON tag.id = sticky.tag_id
    ORDER BY updated_date DESC
    LIMIT ?, ?;
    """
    
    case FetchStickiesWithTagId = """
    SELECT sticky.*, tag.color
    FROM sticky
    LEFT JOIN tag ON tag.id = sticky.tag_id
    WHERE tag_id = ?
    ORDER BY updated_date DESC
    LIMIT ?, ?;
    """
    
    case DeleteSticky = """
    DELETE FROM sticky
    WHERE id = ?;
    """
    
    case FetchTagName = """
    SELECT tag.name
    FROM tag
    WHERE id = ?;
    """
}

enum BeeSqliteHelperError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
    case CreateTable(message: String)
}
