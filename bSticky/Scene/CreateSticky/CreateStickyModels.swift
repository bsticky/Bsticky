//
//  CreateBsModel.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

enum CreateSticky {
    struct StickyFormFields {
        // Contents
        var id: Int
        var contentsType: Int
        var text: String
        var filePath: String
        var contentsAttributeId: Int
        // Misc
        var createdDate: Int
        var updatedDate: Int
    }
    
    enum CreateSticky {
        struct Request {
            var stickyFormFields: StickyFormFields
        }
        struct Response {
            var sticky: Sticky?
        }
        struct ViewModel {
            var sticky: Sticky?
        }
    }
    
    enum EditSticky {
        struct Request{
        }
        struct Response {
            var sticky: Sticky
        }
        struct ViewModel {
            var createFormFields: StickyFormFields
        }
    }
    
    enum UpdateSticky {
        struct Request {
            var createFormFields: StickyFormFields
        }
        struct Response {
            var sticky: Sticky?
        }
        struct ViewModel {
            var sticky: Sticky?
        }
    }
    
    enum SetTagAttribute {
        struct Request {
        }
        struct Response {
            var tagColor: String?
        }
        struct ViewModel {
            var tagColor: String?
        }
    }
}
