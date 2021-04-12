//
//  ManageTagPresenter.swift
//  bSticky
//
//  Created by mima on 05/01/2021.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

import UIKit

protocol ManageTagPresentationLogic {
    func presentTagToEdit(response: ManageTag.EditTag.Response)
    func presentTagsToChoose(response: ManageTag.ChooseTag.Response)
    func presentUpdatedTag(response: ManageTag.UpdateTag.Response)
    func presentCreatedTag(response: ManageTag.CreateTag.Response)
    func presentDeletedTag(response: ManageTag.DeleteTag.Response)
}

class ManageTagPresenter: ManageTagPresentationLogic {
    weak var viewController: ManageTagDisplayLogic?
    
    // MARK: - Edit tag
    
    func presentTagToEdit(response: ManageTag.EditTag.Response) {
        let tag = response.tag
        //let date = "Created on " + convertDate(since1970: tag.createdDate)
        let date = "Created on " + BeeDateFormatter.convertDate(since1970: tag.createdDate)

        let viewModel = ManageTag.EditTag.ViewModel(tagFormFields:
            ManageTag.TagFormFields(
                id: Int(tag.id), name: tag.name, color: tag.color, createdDate: date, description: tag.description!))

        viewController?.displayTagToEdit(viewModel: viewModel)
    }
    
    
    // MARK: - Choose tag
    
    func presentTagsToChoose(response: ManageTag.ChooseTag.Response) {
        var displayedTags: [ManageTag.ChooseTag.ViewModel.DisplayedTag] = []
        for tag in response.tags {
            let displayedTag = ManageTag.ChooseTag.ViewModel.DisplayedTag(id: tag.id, name: tag.name, color: tag.color, activated: tag.activated)
            displayedTags.append(displayedTag)
        }
        
        let viewModel = ManageTag.ChooseTag.ViewModel(displayedTags: displayedTags)
        viewController?.displayTagsToChoose(viewModel: viewModel)
    }
    
    
    // MARK: -  Create tag
    
    func presentCreatedTag(response: ManageTag.CreateTag.Response) {
        let viewModel = ManageTag.CreateTag.ViewModel(tag: response.tag)
        viewController?.displayCreatedTag(viewModel: viewModel)
    }
    
    
    // MARK: - Update tag
    
    func presentUpdatedTag(response: ManageTag.UpdateTag.Response) {
        let viewModel = ManageTag.UpdateTag.ViewModel(tag: response.tag)
        viewController?.displayUpdatedTag(viewModel: viewModel)
    }
    
    // MARK: - Delete tag
    
    func presentDeletedTag(response: ManageTag.DeleteTag.Response) {
        let viewModel = ManageTag.DeleteTag.VieWModel(tagId: response.tagId)
        viewController?.displayDeletedTag(viewModel: viewModel)
    }


    /*
    // MARK: - Helper functions
    func convertDate(since1970: Int) -> String {
        
        let time = Date(timeIntervalSince1970: TimeInterval(since1970))
        
        let dateFormatter_v2 = DateFormatter()
        //dateFormatter_v2.dateFormat = "MMM dd,yyyy h:mm a"
        dateFormatter_v2.dateFormat = "MMM dd,yyyy"
        
        let date = dateFormatter_v2.string(from: time)
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MMM dd,yyyy HH:MM"
        
        return date
    }
    */
}
