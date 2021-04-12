//
//  StartScenePresenter.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

protocol StartBeePresentationLogic {
    func presentFetchedTags(response: StartBee.FetchTags.Response)
    func presentStartCreateSticky(response: StartBee.StartCreateSticky.Response)
    func presentStartListStickies(response: StartBee.StartListStickies.Response)
    func presentStartManageTag(response: StartBee.StartManageTag.Response)
}

class StartBeePresenter: StartBeePresentationLogic {
    
    weak var viewController: StartBeeDisplayLogic?

    // MARK: - Fetch tags
    
    func presentFetchedTags(response: StartBee.FetchTags.Response) {
        var tag: Tag
        let tags = response.tags
        var viewModel = StartBee.FetchTags.ViewModel(displayedTags: [])

        for i in 1...viewController!.numberOfTags {
            // Find activated tag
            if let tagIndex = tags.firstIndex(where: { $0.position == i && $0.activated == true}) {
                tag = tags[tagIndex]
            }
            else {
                // TODO: get color from user defaults
                tag = Tag(id: 0, name: "", color: "#F4116F", position: 0, activated: true, createdDate: 0, description: "")
            }
            
            let displayedTag = StartBee.FetchTags.ViewModel.DisplayedTag(id: tag.id, name: tag.name, color: tag.color)
            
            viewModel.displayedTags.append(displayedTag)
        }
        viewController?.displayFetchedTags(viewModel: viewModel)
    }
    
    // MARK: - Start ManageTag scene
    
    func presentStartManageTag(response: StartBee.StartManageTag.Response) {
        let viewModel = StartBee.StartManageTag.ViewModel()
        viewController?.displayManageTag(viewModel: viewModel)
    }
    
    
    // MARK: - Start CreateSticky scene
    
    func presentStartCreateSticky(response: StartBee.StartCreateSticky.Response) {
        let viewModel = StartBee.StartCreateSticky.ViewModel()
        viewController?.displayCreateSticky(viewModel: viewModel)
    }
    
    
    // MARK: - Start ListSticky scene
    
    func presentStartListStickies(response: StartBee.StartListStickies.Response) {
        let viewModel = StartBee.StartListStickies.ViewModel()
        viewController?.displayListStickies(viewModel: viewModel)
    }
}
