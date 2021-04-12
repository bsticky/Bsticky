//
//  ShowStickyModel.swift
//  bSticky
//
//  Created by mima on 2021/02/19.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//
import UIKit

enum ManageSticky {
    struct DisplayedSticky {
        var id: Int
        var tagName: String
        var tagColor: UIColor
        var date: String
        var contentsType: ContentsType
        var text: String?
        var image: UIImage?
        var audioURL: URL?
    }
    
    enum FetchSticky {
        struct Request {
        }
        
        struct Response {
            var managedSticky: ManagedSticky?
        }
        
        struct ViewModel {
            var displayedSticky: DisplayedSticky?
        }
    }
    
    enum FetchAdjacentSticky {
        struct Request {
            var isNext: Bool
        }
        
        struct Response {
            var managedSticky: ManagedSticky?
        }
        
        struct ViewModel {
            var displayedSticky: DisplayedSticky?
        }
    }
    
    enum UpdateSticky {
        // Edit text fields
        struct Request {
            var stickyFormFields: StickyFormFields
            
            struct StickyFormFields {
                var id: Int
                var text: String
            }
        }
        
        struct Response {
            var sticky: Sticky
        }
        
        struct ViewModel {
            var sticky: Sticky
        }
        
    }
    
    enum DeleteSticky {
        struct Request {
        }
        
        struct Response {
            var stickyId: Int?
        }
        
        struct VieWModel {
            var stickyId: Int?
        }
    }
    
    
}
