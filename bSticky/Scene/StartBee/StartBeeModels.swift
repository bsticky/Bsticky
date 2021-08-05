//
//  StartSceneModels.swift
//  bSticky
//
//  Created by mima on 21/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

enum StartBee {
    // Use cases
    enum FetchTags {
        struct Request {
        }
        struct Response {
            var tags: [Tag]
        }
        struct ViewModel {
            struct DisplayedTag {
                var id: Int
                var name: String
                var color: String
            }
            var displayedTags: [DisplayedTag]
        }
    }
    
    enum StartManageTag {
        struct Request {
            var tagId: Int
            var tagButtonPosition: Int
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum StartCreateSticky {
        struct Request {
            var tagId: Int
            var tagColor: String
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
    
    enum StartListStickies {
        struct Request {
            var tagId: Int?
            var tagName: String?
            var tagColor: String?
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
