//
//  CreateStickyPresenter.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

protocol CreateStickyPresentationLogic {
    func presentCreateSticky(response: CreateSticky.CreateSticky.Response)
    func presentTagAttribute(response: CreateSticky.SetTagAttribute.Response)
    
    
    func presentStickyToEdit(response: CreateSticky.CreateSticky.Response)
    func presentUpdatedSticky(response: CreateSticky.UpdateSticky.Response)
}

class CreateStickyPresenter: CreateStickyPresentationLogic {
    
    weak var viewController: CreateStickyDisplayLogic?
    
    // MARK: - Create sticky
    
    func presentCreateSticky(response: CreateSticky.CreateSticky.Response) {
        let viewModel = CreateSticky.CreateSticky.ViewModel(sticky: response.sticky)
        viewController?.displayCreatedSticky(viewModel: viewModel)
    }
    
    // MARK: - Set tag attribute
    
    func presentTagAttribute(response: CreateSticky.SetTagAttribute.Response) {
        let viewModel = CreateSticky.SetTagAttribute.ViewModel(tagColor: response.tagColor)
        viewController?.displayTagAttribute(viewModel: viewModel)
    }
    
    func presentStickyToEdit(response: CreateSticky.CreateSticky.Response) {
    }
    
    func presentUpdatedSticky(response: CreateSticky.UpdateSticky.Response) {
    }
    
    
}
