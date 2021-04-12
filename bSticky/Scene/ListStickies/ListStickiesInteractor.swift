//
//  ListStickiesInteractor.swift
//  bSticky
//
//  Created by mima on 2021/02/05.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

protocol ListStickiesBusinessLogic {
    func fetchStickies(request: ListStickies.FetchStickies.Request)
    func manageSticky(request: ListStickies.ManageSticky.Request)
}

protocol ListStickiesDataStore {
    var tagId: Int? { get set }
    var tagName: String? { get set }
    var tagColor: String? { get set }
    var chosenStickyId: Int? { get }
}

class ListStickiesInteractor: ListStickiesBusinessLogic, ListStickiesDataStore {
    
    var beeWorker = BeeWorker(BeeDB: BeeDatabase())
    var presenter: ListStickiesPresentationLogic?
    
    var tagId: Int?
    var tagName: String?
    var tagColor: String?
    var chosenStickyId: Int?
    
    // MARK: - Fetch stickies
    
    let limit: Int = 25 // load 25 Stickies by default
    var fetchedStickies: [Sticky]?

    func fetchStickies(request: ListStickies.FetchStickies.Request) {
        if tagId == 0 || tagId == nil {
            // Fetch stickies without specific tag
            beeWorker.fetchStickies(offset: request.offset, limit: limit , completionHandler: { (stickies) -> Void in
                self.fetchedStickies = stickies
                let response = ListStickies.FetchStickies.Response(tagName: "",
                                                                   tagColor: "#FFFFFF", // CHange color
                                                                   stickies: stickies)
                self.presenter?.presentFetchedStickies(response: response)
            })
        } else {
            // Fetch stickies with specific tag
            beeWorker.fetchStickiesWithTagId(tagId: tagId!, offset: request.offset, limit: limit, completionHandler: { (stickies) -> Void in
                self.fetchedStickies = stickies
                let response = ListStickies.FetchStickies.Response(tagName: self.tagName!,
                                                                   tagColor: self.tagColor!,
                                                                   stickies: stickies)
                self.presenter?.presentFetchedStickies(response: response)
            })
        }
    }
    
    // MARK: - Manage sticky
    
    func manageSticky(request: ListStickies.ManageSticky.Request) {
        chosenStickyId = request.stickyId
        let response = ListStickies.ManageSticky.Response()
        self.presenter?.presentManageSticky(response: response)
    }
}
