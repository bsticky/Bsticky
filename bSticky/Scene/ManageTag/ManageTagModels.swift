//
//  ManageTagModels.swift
//  bSticky
//
//  Created by mima on 31/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import UIKit

enum ManageTag {
    
    struct TagFormFields {
        var id: Int
        var name: String
        var color: String
        var createdDate: String
        var description: String
    }
    
    enum CreateTag {
        struct Request {
            var tagFormFields: TagFormFields
        }
        struct Response {
            var tag: Tag?
        }
        struct ViewModel {
            var tag: Tag?
        }
    }
    
    enum EditTag {
        struct Request {
        }
        struct Response {
            var tag: Tag
        }
        struct ViewModel {
            var tagFormFields: TagFormFields
        }
    }
    
    enum UpdateTag {
        struct Request {
            var tagFormFields: TagFormFields
        }
        struct Response {
            var tag: Tag?
        }
        struct ViewModel {
            var tag: Tag?
        }
    }
    
    enum DeleteTag {
        struct Request {
            var tagId: Int
        }
        struct Response {
            var tagId: Int?
        }
        struct VieWModel {
            var tagId: Int?
        }
    }
    
    enum ChooseTag {
        struct Request {
        }
        struct Response {
            var tags: [Tag]
        }
        struct ViewModel {
            var displayedTags: [DisplayedTag]?
            
            struct DisplayedTag {
                var id: Int
                var name: String
                var color: String
                var activated: Bool
            }
        }
    }
}
