//
//  ListStickiesModels.swift
//  bSticky
//
//  Created by mima on 15/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//
import UIKit

enum ListStickies {
    
    enum FetchStickies {
        struct Request {
            var tagId: Int?
            var offset: Int
        }
        struct Response {
            var tagName: String
            var tagColor: String
            var stickies: [Sticky]
        }
        struct ViewModel {
            var tagName: String
            var tagColor: String
            var displayedStickies: [DisplayedSticky]
            
            struct DisplayedSticky {
                var id: Int
                var updatedDate: String
                var tagColor: UIColor
                var contentsType: ContentsType
                var text: String!
                var fileName: String!
            }
        }
    }
    
    enum ManageSticky {
        struct Request {
            var stickyId: Int
        }
        struct Response {
        }
        struct ViewModel {
        }
    }
}
