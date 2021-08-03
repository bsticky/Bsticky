//
//  StartSceneInteractor.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

protocol StartBeeBusinessLogic {
    func fetchTags(request: StartBee.FetchTags.Request)
    func startManageTag(request: StartBee.StartManageTag.Request)
    func startCreateSticky(request: StartBee.StartCreateSticky.Request)
    func startListStickies(request: StartBee.StartListStickies.Request)
}

protocol StartBeeDataStore {
    var fetchedTags: [Tag]? { get }
    var chosenTagId: Int? { get }
    var chosenTagName: String? { get }
    var chosenTagColor: String? { get }
    var chosenTagButtonPosition: Int? { get }
}

class StartBeeInteractor: StartBeeBusinessLogic, StartBeeDataStore {

    var beeWorker = BeeWorker(BeeDB: BeeDatabase())
    //var stickyWorker = BeeWorker(BeeDB: BeeMemDB())
    var presenter: StartBeePresentationLogic?
    
    var fetchedTags: [Tag]?
    var chosenTagId: Int?
    var chosenTagName: String?
    var chosenTagColor: String?
    var chosenTagButtonPosition: Int?
    
    // MARK: - Fetch tags
    
    func fetchTags(request: StartBee.FetchTags.Request) {
        beeWorker.fetchTags {(tags) -> Void in
            // tag[0] = default tag
            self.fetchedTags = Array(tags.dropFirst())
            
            let response = StartBee.FetchTags.Response(tags: tags)
            self.presenter?.presentFetchedTags(response: response)
        }
    }
    
    // MARK: - Start manage tag
    
    func startManageTag(request: StartBee.StartManageTag.Request) {
        chosenTagId = request.tagId
        chosenTagButtonPosition = request.tagButtonPosition

        let response = StartBee.StartManageTag.Response()
        presenter?.presentStartManageTag(response: response)
    }
    
    // MARK: - Start create sticky
    
    func startCreateSticky(request: StartBee.StartCreateSticky.Request) {
        chosenTagId = request.tagId
        chosenTagColor = request.tagColor

        let response = StartBee.StartCreateSticky.Response()
        presenter?.presentStartCreateSticky(response: response)
    }
    
    // MARK: - Start list stickies
    
    func startListStickies(request: StartBee.StartListStickies.Request) {
        chosenTagId = request.tagId
        chosenTagName = request.tagName
        chosenTagColor = request.tagColor
        
        let response = StartBee.StartListStickies.Response()
        presenter?.presentStartListStickies(response: response)
    }
}
