//
//  StickyMemDB.swift
//  bSticky
//
//  Created by mima on 15/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

class BeeMemDB: StickyDBProtocol{
    
    static var tags = [
        Tag(id: 0, name: "One", color: "#FF1D00", position: 0, activated: true, createdDate: 20201222, description: "description of tag one"),
        Tag(id: 1, name: "Two", color: "#43FF5D", position: 1, activated: true, createdDate: 20201222, description: "--"),
        Tag(id: 2, name: "Three", color: "#FF7016", position: 2, activated: true,createdDate: 20201222, description: "---"),
        Tag(id: 3, name: "Four", color: "#FFEE34", position: 3, activated: true,createdDate: 20201212, description: "----"),
        Tag(id: 4, name: "Five", color: "#0823FF", position: 4, activated: true ,createdDate: 20201212, description: "-----"),
        Tag(id: 5, name: "Six", color: "#B72AFF", position: 5, activated: true,createdDate: 20201212, description: "------")
    ]
    
    static var stickies = [
        Sticky(id: 0, tagId: 0, tagColor: "#203050", contentsType: ContentsType.Text, text: "", filePath: "", createdDate: 0, updatedDate: 0)
    ]

    
    // CRUD inner closure
    func fetchTags(completionHandler: @escaping (() throws -> [Tag]) -> Void) {
        completionHandler { return type(of: self).tags}
    }
    
    func fetchTag(id: Int, completionHandler: @escaping (() throws -> Tag?) -> Void) {
        if let index = indexOfTagWithId(id: id) {
            completionHandler { return type(of: self).tags[index]}
        } else {
            completionHandler { throw BeeDBError.CannotFetch("Cannot fetch tag with id \(id)")}
        }
    }
    
    func createTag(tagToCreate: Tag, completionHandler: @escaping (() throws -> Tag?) -> Void) {
    }
    
    func updateTag(tagToUpdate: Tag, completionHandler: @escaping (() throws -> Tag?) -> Void) {
        if let index = indexOfTagWithId(id: tagToUpdate.id) {
            type(of: self).tags[index] = tagToUpdate
            completionHandler { return tagToUpdate}
        } else {
            completionHandler { throw BeeDBError.CannotUpdate("Cannot fetch tag with id \(String(describing: tagToUpdate.id)) to update")}
        }
    }
    
    func deleteTag(tagId: Int, completionHandler: @escaping (() throws -> Int?) -> Void) {
    }
    
    
    func createSticky(stickyToCreate: Sticky, completionHandler: @escaping (() throws -> Sticky?) -> Void) {
        let sticky = stickyToCreate
        
        type(of: self).stickies.append(sticky)
        completionHandler{ return sticky}
    }
    
    func fetchSticky(stickyId: Int,
                     completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
    
    }

    func fetchStickies(offset: Int, limit: Int, completionHandler: @escaping (() throws -> [Sticky]) -> Void) {
        
    }
    
    func fetchStickiesyWithTagId(tagId: Int, offset: Int, limit: Int, completionHandler: @escaping (() throws -> [Sticky]) -> Void){
        
    }
    
    func fetchAdjacentSticky(updatedDate: Int, isNext: Bool, completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
        
    }
    
    func fetchAdjacentStickyWithinTag(updatedDate: Int, isNext: Bool, tagId: Int, completionHandler: @escaping (() throws -> ManagedSticky?) -> Void) {
        
    }
    
    func updateSticky(stickyToUpdate: Sticky, completionHandler: @escaping (() throws -> Sticky?) -> Void) {
    }
    
    func deleteSticky(stickyId: Int, completionHandler: @escaping (() throws -> Int?) -> Void) {
    }
    
    func fetchTagName(tagId: Int, completionHandler: @escaping (() throws -> String) -> Void) {
    }
    
    // Helper function
    private func indexOfTagWithId(id: Int?) -> Int? {
        return type(of: self).tags.firstIndex { return $0.id == id}
    }
}
