//
//  StickyDataBase.swift
//  bSticky
//
//  Created by mima on 15/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation
import SQLite3

class BeeDatabase: StickyDBProtocol{
    private var dbHelper: BeeSqliteHelper?

    init() {
        // The directory the application uses to store the sqlite database file.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // uses file named "BeeSticky.sqlite" in the application's documents derectory.
        let databaseURL = urls[urls.endIndex-1].appendingPathComponent("BeeSticky.sqlite")
        
        // Opening a connection
        self.dbHelper = BeeSqliteHelper(databaseURL: databaseURL.absoluteString)
    }
    
    deinit {
        // close database
    }

    // MARK: Create Tag
    
    func createTag(tagToCreate: Tag, completionHandler: @escaping (() throws -> Tag?) -> Void) {
        // It throws NoTable error if table doed not exist then create table
        do {
            let tag = try dbHelper?.insertTag(tag: tagToCreate)
            completionHandler { return tag }
        } catch {
            completionHandler { throw BeeDBError.CannotCreate(
                "Cannot create tag | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    // MARK: Fetch tags
    
    func fetchTags(completionHandler: @escaping (() throws -> [Tag]) -> Void) {
        do {
            let result = try dbHelper?.fetchTags()
            completionHandler{ return result!}
        } catch {
            completionHandler{ throw BeeDBError.CannotFetch(
                "Cannot fetch tags | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    func fetchTag(id: Int, completionHandler: @escaping (() throws -> Tag?) -> Void) {
    }
    
    
    // MARK: Update tag
    
    func updateTag(tagToUpdate: Tag, completionHandler: @escaping (() throws -> Tag?) -> Void) {
        do {
            let tag = try dbHelper?.updateTag(tag: tagToUpdate)
            completionHandler{ return tag }
        } catch {
            completionHandler{ throw BeeDBError.CannotUpdate(
                "Cannot update tag | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    // MARK: Delete tag
    
    func deleteTag(tagId: Int, completionHandler: @escaping (() throws -> Int?) -> Void) {
        do {
            let tagId = try dbHelper?.deleteTag(tagId: tagId)
            completionHandler{ return tagId}
        } catch {
            completionHandler{ throw BeeDBError.CannotDelete(
                "Cannot delete tag | | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    // MARK: - Sticky
    
    func createSticky(stickyToCreate: Sticky, completionHandler: @escaping (() throws -> Sticky?) -> Void) {
        do {
            let sticky = try dbHelper?.insertSticky(sticky: stickyToCreate)
            completionHandler { return sticky}
        } catch {
            completionHandler { throw BeeDBError.CannotCreate(
                "Cannot create sticky | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    func fetchSticky(stickyId: Int, completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
        do {
            let managedSticky = try dbHelper?.fetchManagedSticky(stickyId: stickyId)
            completionHandler { return managedSticky }
        } catch {
            completionHandler { throw BeeDBError.CannotFetch(
                "Cannot fetch sticky | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    func fetchStickies(offset: Int, limit: Int, completionHandler: @escaping (() throws -> [Sticky]) -> Void) {
        do {
            let stickies = try dbHelper?.fetchStickies(offset: offset, limit: limit)
            completionHandler { return stickies! }
        } catch {
            completionHandler { throw BeeDBError.CannotFetch(
                "Cannot fetch stickies | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    func fetchStickiesyWithTagId(tagId: Int, offset: Int, limit: Int, completionHandler: @escaping (() throws -> [Sticky]) -> Void) {
        do {
            let stickies = try dbHelper?.fetchStickiesWithTagId(tagId: tagId, offset: offset, limit: limit)
            completionHandler { return stickies! }
        } catch {
            completionHandler { throw BeeDBError.CannotFetch(
                "Cannot fetch stickies | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    func fetchAdjacentSticky(updatedDate: Int, isNext: Bool, completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
        do {
            let managedSticky = try dbHelper?.fetchAdjacentSticky(updatedDate: updatedDate, isNext: isNext)
            completionHandler { return managedSticky }
        } catch {
            if dbHelper?.errorMessage == "not an error" {
                completionHandler { throw BeeDBError.NoMoreRowsAvailable}
            } else {
                completionHandler { throw BeeDBError.CannotFetch("Cannot fetch stickies | \(String(describing: dbHelper?.errorMessage))")}
            }
        }
    }


    func fetchAdjacentStickyWithinTag(updatedDate: Int, isNext: Bool, tagId: Int, completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
        do {
            let managedSticky = try dbHelper?.fetchAdjacentStickyWithinTag(updatedDate: updatedDate, isNext: isNext, tagId: tagId)
            completionHandler { return managedSticky }
        } catch {
            if dbHelper?.errorMessage == "not an error" {
                completionHandler { throw BeeDBError.NoMoreRowsAvailable}
            } else {
                completionHandler { throw BeeDBError.CannotFetch("Cannot fetch sticky | \(String(describing: dbHelper?.errorMessage))")}
            }
        }
    }
    
    func updateSticky(stickyToUpdate: Sticky, completionHandler: @escaping (() throws -> Sticky?) -> Void) {
    }
    
    func deleteSticky(stickyId: Int, completionHandler: @escaping (() throws -> Int?) -> Void) {
        do {
            let stickyId = try dbHelper?.deleteSticky(stickyId: stickyId)
            completionHandler{ return stickyId }
        } catch {
            completionHandler{ throw BeeDBError.CannotDelete(
                "Cannot delete sticky | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
    
    // MARK: - Extra functions
    
    func fetchTagName(tagId: Int, completionHandler: @escaping (() throws -> String) -> Void) {
        do {
            let tagName = try dbHelper?.fetchTagName(tagId: Int32(tagId))
            completionHandler { return tagName! }
        } catch {
            completionHandler { throw BeeDBError.CannotFetch(
                "Cannot fetch tag name | \(String(describing: dbHelper?.errorMessage))")}
        }
    }
}
