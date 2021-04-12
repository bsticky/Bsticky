//
//  ManageTagInteractor.swift
//  bSticky
//
//  Created by mima on 02/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import Foundation

protocol ManageTagBuisinessLogic {
    var tagsToChoose: [Tag]? { get set }
    var chosenTagId: Int? { get }
    var chosenTagButtonPosition: Int? { get }
    
    func showTagToEdit(request: ManageTag.EditTag.Request)
    func showTagsToChoose(request: ManageTag.ChooseTag.Request)
    
    func createTag(request: ManageTag.CreateTag.Request)
    func updateTag(request: ManageTag.UpdateTag.Request)
    func deleteTag(request: ManageTag.DeleteTag.Request)
}


protocol ManageTagDataStore {
    var tagsToChoose: [Tag]? { get set }
    var chosenTagId: Int? { get set }
    var chosenTagButtonPosition: Int? { get set }
}

class ManageTagInteractor: ManageTagBuisinessLogic, ManageTagDataStore {
    
    var presenter: ManageTagPresentationLogic?
    var beeWorker = BeeWorker(BeeDB: BeeDatabase())
    
    var chosenTagId: Int?
    var tagsToChoose: [Tag]?
    var chosenTagButtonPosition: Int?
    
    // MARK: -  Edit tag
    
    func showTagToEdit(request: ManageTag.EditTag.Request) {
        // If tag is exist show tag to edit
        if let tagToEdit = findTagWithIdfromTagsToChoose(id: chosenTagId) {
            presenter?.presentTagToEdit(response: ManageTag.EditTag.Response(tag: tagToEdit))
        }
    }

    // MARK: - Choose Tag
    
    func showTagsToChoose(request: ManageTag.ChooseTag.Request) {
        presenter?.presentTagsToChoose(response: ManageTag.ChooseTag.Response(tags: tagsToChoose ?? []))
    }

    // MARK: - Create tag
    
    func createTag(request: ManageTag.CreateTag.Request) {
        let name = request.tagFormFields.name
        let color = request.tagFormFields.color
        let position = chosenTagButtonPosition! + 1
        let activated = true
        let createdDate = Int(Date().timeIntervalSince1970)
        let description = request.tagFormFields.description
        
        let tagToCreate = Tag(id: 0, name: name, color: color, position: position, activated: activated, createdDate: createdDate, description: description)

        beeWorker.createTag(tagToCreate: tagToCreate) { (tag) in
            let response = ManageTag.CreateTag.Response(tag: tag)
            self.presenter?.presentCreatedTag(response: response)
        }
    }
    
    // MARK: - Update tag
    
    func updateTag(request: ManageTag.UpdateTag.Request) {
        guard let tagToUpdate = buildTagfromUpdateTagFormFields(request.tagFormFields) else {
            return
        }
        
        beeWorker.updatedTag(tagToUpdate: tagToUpdate) { (tag) in
            let response = ManageTag.UpdateTag.Response(tag: tag)
            self.presenter?.presentUpdatedTag(response: response)
        }
    }

    // MARK: - Delete tag
    
    func deleteTag(request: ManageTag.DeleteTag.Request) {
        beeWorker.deleteTag(tagId: request.tagId) { (tagId) in
            let index = self.tagsToChoose?.firstIndex(where: { $0.id == tagId})
            self.tagsToChoose?.remove(at: index!)
            let response = ManageTag.DeleteTag.Response(tagId: tagId)
            self.presenter?.presentDeletedTag(response: response)
        }
    }
    
    // MARK: - Helper function
    
    private func buildTagfromUpdateTagFormFields(_ tagFormFields: ManageTag.TagFormFields) -> Tag? {
        if var tag = findTagWithIdfromTagsToChoose(id: tagFormFields.id) {
            if tagFormFields.createdDate == "" {
                // Chosed tag
                tag.position = chosenTagButtonPosition! + 1
                tag.activated = true
            } else {
                // Edited tag
                tag.name = tagFormFields.name
                tag.color = tagFormFields.color
                tag.description = tagFormFields.description
            }
            return tag
        } else {
            return nil
        }
    }

    private func findTagWithIdfromTagsToChoose(id: Int?) -> Tag? {
        if let index = self.tagsToChoose?.firstIndex(where: { $0.id == id}) {
            return (self.tagsToChoose?[index])!
        } else {
            return nil
        }
    }
    
}

