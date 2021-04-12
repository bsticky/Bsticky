//
//  ListStickiesPresenter.swift
//  bSticky
//
//  Created by mima on 2021/02/05.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//
import UIKit

protocol ListStickiesPresentationLogic {
    func presentFetchedStickies(response: ListStickies.FetchStickies.Response)
    func presentManageSticky(response: ListStickies.ManageSticky.Response)
}

class ListStickiesPresenter: ListStickiesPresentationLogic {

    weak var viewController: ListStickiesDisplayLogic?
    
    // MARK: - Fetch stickies
    
    var thumbnail: UIImage?
    
    func presentFetchedStickies(response: ListStickies.FetchStickies.Response) {
        var displayedStickies: [ListStickies.FetchStickies.ViewModel.DisplayedSticky] = []
        
        for sticky in response.stickies {
            var displayedSticky: ListStickies.FetchStickies.ViewModel.DisplayedSticky!
            
            let updatedDate = BeeDateFormatter.convertDate(since1970: sticky.updatedDate)
            let tagColor = UIColor(sticky.tagColor)
            
            switch sticky.contentsType {
            case .Image:
                displayedSticky = ListStickies.FetchStickies.ViewModel.DisplayedSticky(
                    id: sticky.id, updatedDate: updatedDate, tagColor: tagColor, contentsType: sticky.contentsType, fileName: sticky.filePath )
            default:
                displayedSticky = ListStickies.FetchStickies.ViewModel.DisplayedSticky(
                    id: sticky.id, updatedDate: updatedDate, tagColor: tagColor, contentsType: sticky.contentsType, text: sticky.text)
            }
            displayedStickies.append(displayedSticky)
        }
        
        let viewModel = ListStickies.FetchStickies.ViewModel(tagName: response.tagName,
                                                             tagColor: response.tagColor,
                                                             displayedStickies: displayedStickies)
        viewController?.displayFetchedStickies(viewModel: viewModel)
    }
    
    // MARK: - Manage sticky
    
    func presentManageSticky(response: ListStickies.ManageSticky.Response) {
        let viewModel = ListStickies.ManageSticky.ViewModel()
        viewController?.displayManageSticky(viewModel: viewModel)
    }
}

