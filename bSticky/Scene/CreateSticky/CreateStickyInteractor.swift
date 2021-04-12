//
//  CreateStickyInteractor.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

protocol CreateStickyBusinessLogic {
    func createSticky(request: CreateSticky.CreateSticky.Request)
    func setTagAttribute(request: CreateSticky.SetTagAttribute.Request)
}

protocol CreateStickyDataStore {
    var tagId: Int? { get set }
    var tagColor: String? { get set }
}

class CreateStickyInteractor: CreateStickyBusinessLogic, CreateStickyDataStore {
    
    var presenter: CreateStickyPresentationLogic?
    var beeWorker = BeeWorker(BeeDB: BeeDatabase())

    var tagId: Int?
    var tagColor: String?

    // MARK: - Create sticky
    
    func createSticky(request: CreateSticky.CreateSticky.Request) {
        let stickyToCreate = buildStickyFromStickyFormFields(request.stickyFormFields)
        
        beeWorker.createSticky(stickyToCreate: stickyToCreate) { (sticky: Sticky?) in
            let response = CreateSticky.CreateSticky.Response(sticky: sticky)
            self.presenter?.presentCreateSticky(response: response)
        }
    }
    
    // MARK: - Set tag attribute
    
    func setTagAttribute(request: CreateSticky.SetTagAttribute.Request) {
        let response = CreateSticky.SetTagAttribute.Response(tagColor: tagColor)
        self.presenter?.presentTagAttribute(response: response)
    }
    
    // MARK: - Helper function
    
    private func buildStickyFromStickyFormFields(_ stickyFormFields: CreateSticky.StickyFormFields) -> Sticky {
        let contentsType = stickyFormFields.contentsType

        return Sticky(id: 0, tagId: self.tagId!, tagColor: self.tagColor! , contentsType: ContentsType(rawValue: contentsType)!, text: stickyFormFields.text, filePath: stickyFormFields.filePath, createdDate: stickyFormFields.createdDate, updatedDate: stickyFormFields.updatedDate)
    }
}
