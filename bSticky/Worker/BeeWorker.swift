//  StickyWorker.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

class BeeWorker {
    var beeDB: StickyDBProtocol
    
    init(BeeDB: StickyDBProtocol) {
        self.beeDB = BeeDB
    }

    // MARK: - Tag
    
    func createTag(tagToCreate: Tag, completionHandler: @escaping (Tag?) -> Void) {
        beeDB.createTag(tagToCreate: tagToCreate, completionHandler: { (tag: () throws -> Tag?) -> Void in
            do {
                let tag = try tag()
                DispatchQueue.main.async {
                    completionHandler(tag)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                
            }
        })
    }
    
    func fetchTags(compeletionHandler: @escaping ([Tag]) -> Void) {
        beeDB.fetchTags { (tags: () throws -> [Tag]) -> Void in
            do {
                let tags = try tags()
                DispatchQueue.main.async {
                    compeletionHandler(tags)
                }
            } catch {
                DispatchQueue.main.async {
                    compeletionHandler([])
                }
            }
        }
    }
    

    func updatedTag(tagToUpdate: Tag, completionHandler: @escaping (Tag?) -> Void) {
        beeDB.updateTag(tagToUpdate: tagToUpdate, completionHandler: { (tag: () throws -> Tag?) -> Void in
            do {
                let tag = try tag()
                DispatchQueue.main.async {
                    completionHandler(tag)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        })
    }
    
    func deleteTag(tagId: Int, completionHandler: @escaping (Int?) -> Void) {
        beeDB.deleteTag(tagId: tagId, completionHandler: { (tag: () throws -> Int?) -> Void in
            do {
                let tagId = try tag()
                DispatchQueue.main.async {
                    completionHandler(tagId)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        })
    }

    // MARK: - Sticky
    
    func createSticky(stickyToCreate: Sticky, completionHandler: @escaping (Sticky?) -> Void) {
        beeDB.createSticky(stickyToCreate: stickyToCreate) { (sticky: () throws -> Sticky?) -> Void in
            do {
                let sticky = try sticky()
                DispatchQueue.main.async {
                    completionHandler(sticky)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func fetchSticky(stickyId: Int, completionHandler: @escaping (ManagedSticky?) -> Void) {
        beeDB.fetchSticky(stickyId: stickyId) { (sticky: () throws -> ManagedSticky?) -> Void in
            do {
                let managedSticky = try sticky()
                DispatchQueue.main.async {
                    completionHandler( managedSticky )
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func fetchStickies(offset:Int, limit: Int, completionHandler: @escaping ([Sticky]) -> Void) {
        beeDB.fetchStickies(offset: offset, limit: limit) { (stickies: () throws -> [Sticky]) -> Void in
            do {
                let stickies = try stickies()
                DispatchQueue.main.async {
                    completionHandler(stickies)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    func fetchStickiesWithTagId(tagId: Int, offset: Int, limit: Int, completionHandler: @escaping ([Sticky]) -> Void) {
        beeDB.fetchStickiesyWithTagId(tagId: tagId, offset: offset, limit: limit) { (stickies: () throws -> [Sticky]) -> Void in
            do {
                let stickies = try stickies()
                DispatchQueue.main.async {
                    completionHandler(stickies)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    func fetchAdjacentSticky(updatedDate: Int, isNext: Bool, completionHandler: @escaping (ManagedSticky?) -> Void) {
        beeDB.fetchAdjacentSticky(updatedDate: updatedDate, isNext: isNext) { (managedSticky: () throws -> ManagedSticky?) -> Void in
            do {
                let managedSticky = try managedSticky()
                DispatchQueue.main.async {
                    completionHandler(managedSticky)
                }
            } catch BeeDBError.NoMoreRowsAvailable {
                var managedSticky: ManagedSticky
                
                if isNext {
                    managedSticky = ManagedSticky(id: 0, tagColor: "", tagName: "", contentsType: .Text, text: "\n\n\nNo more next stickies available", fileName: "", createdDate: updatedDate + 1, updatedDate: updatedDate + 1)
                } else {
                    managedSticky = ManagedSticky(id: 0, tagColor: "", tagName: "", contentsType: .Text, text: "\n\n\nNo more previous stickies available", fileName: "", createdDate: updatedDate - 1, updatedDate: updatedDate - 1)
                }
                DispatchQueue.main.async {
                    completionHandler(managedSticky)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func fetchAdjacentStickyWithinTag(updatedDate: Int, isNext: Bool, tagId: Int, completionHandler: @escaping (ManagedSticky?) -> Void) {
        beeDB.fetchAdjacentStickyWithinTag(updatedDate: updatedDate, isNext: isNext, tagId: tagId) {(managedSticky: () throws -> ManagedSticky?) -> Void in
            do {
                let managedSticky = try managedSticky()
                DispatchQueue.main.async {
                    completionHandler(managedSticky)
                }
            } catch BeeDBError.NoMoreRowsAvailable {
                var managedSticky: ManagedSticky
                
                if isNext {
                    managedSticky = ManagedSticky(id: 0, tagColor: "", tagName: "", contentsType: .Text, text: "\n\n\nNo more next stickies available", fileName: "", createdDate: updatedDate + 1, updatedDate: updatedDate + 1)
                } else {
                    managedSticky = ManagedSticky(id: 0, tagColor: "", tagName: "", contentsType: .Text, text: "\n\n\nNo more previous stickies available", fileName: "", createdDate: updatedDate - 1, updatedDate: updatedDate - 1)
                }
                DispatchQueue.main.async {
                    completionHandler(managedSticky)
                }
            } catch  {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func deleteSticky(stickyId: Int, completionHandler: @escaping (Int?) -> Void) {
        beeDB.deleteSticky(stickyId: stickyId, completionHandler: { (sticky: () throws -> Int?) -> Void in
            do {
                let stickyId = try sticky()
                DispatchQueue.main.async {
                    completionHandler(stickyId)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        })
    }
    
    // MARK: - Extra
    
    func fetchTagName(tagId: Int, completionHandler: @escaping (String) -> Void) {
        beeDB.fetchTagName(tagId: tagId) { (tagName: () throws -> String) -> Void in
            do {
                let tagName = try tagName()
                DispatchQueue.main.async {
                    completionHandler(tagName)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler("")
                }
            }
        }
    }
}

// MARK: - Database protocol

protocol StickyDBProtocol {
    // Tag CRUD Operations - Inner closure
    
    func createTag(tagToCreate: Tag,
                   completionHandler: @escaping (() throws -> Tag?) -> Void)
    
    func fetchTags(completionHandler: @escaping (() throws -> [Tag]) -> Void)
    
    func fetchTag(id: Int,
                  completionHandler: @escaping (() throws -> Tag?) -> Void)
    
    func updateTag(tagToUpdate: Tag,
                   completionHandler: @escaping (() throws -> Tag?) -> Void)
    
    func deleteTag(tagId: Int,
                   completionHandler: @escaping (() throws -> Int?) -> Void)

    // Sticky CRUD Operations - Inner closure
    
    func createSticky(stickyToCreate: Sticky,
                      completionHandler: @escaping (() throws -> Sticky?) -> Void)
    
    func fetchSticky(stickyId: Int,
                     completionHandler: @escaping (() throws -> ManagedSticky?) -> Void)
    
    func fetchStickies(offset: Int,
                       limit: Int,
                       completionHandler: @escaping (() throws -> [Sticky]) -> Void)
    
    func fetchStickiesyWithTagId(tagId: Int,
                                 offset: Int,
                                 limit: Int,
                                 completionHandler: @escaping (() throws -> [Sticky]) -> Void)
    
    func fetchAdjacentSticky(updatedDate: Int,
                             isNext: Bool,
                             completionHandler: @escaping (() throws -> ManagedSticky?) -> Void)
    
    func fetchAdjacentStickyWithinTag(updatedDate: Int,
                                      isNext: Bool,
                                      tagId: Int,
                                      completionHandler: @escaping (() throws -> ManagedSticky?) -> Void)
    

    func updateSticky(stickyToUpdate: Sticky,
                      completionHandler: @escaping (() throws -> Sticky?) -> Void)
    
    func deleteSticky(stickyId: Int,
                      completionHandler: @escaping (() throws -> Int?) -> Void)
    
    // Extra operations
    func fetchTagName(tagId: Int, completionHandler: @escaping (() throws -> String) -> Void)
}

enum BeeDBError: Equatable, Error {
    case CannotInit(String)
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
    case NoMoreRowsAvailable
}

func ==(lhs: BeeDBError, rhs: BeeDBError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), . CannotDelete(let b)) where a == b: return true
    default: return false
    }
}

