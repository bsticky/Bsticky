//
//  Seeds.swift
//  bStickyTests
//
//  Created by mima on 18/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//
@testable import bSticky
import XCTest

struct Seeds {
    
    struct Tags {
        static let tags = [
            Tag(id: 1, name: "One", color: "#FF1D00", position: 1, activated: true, createdDate: 20201222, description: "-"),
            Tag(id: 2, name: "Two", color: "#43FF5D", position: 2, activated: true, createdDate: 20201222, description: "--"),
            Tag(id: 3, name: "Three", color: "#FF7016", position: 3, activated: true, createdDate: 20201222, description: "---"),
            Tag(id: 4, name: "Four", color: "#FFEE34", position: 4, activated: true, createdDate: 20201212, description: "----"),
            Tag(id: 5, name: "Five", color: "#0823FF", position: 5, activated: true, createdDate: 20201212, description: "-----"),
            Tag(id: 6, name: "Six", color: "#B72AFF", position: 6, activated: true, createdDate: 20201212, description: "------")
        ]
    }
    
    struct Stickies {
        static let textSticky = Sticky(id: 1, tagId: 1, tagColor: "#111111", contentsType: ContentsType.Text, text: "Test", filePath: "", createdDate: 2021, updatedDate: 2021)
        static let imageSticky = Sticky(id: 2, tagId: 3, tagColor: "#222222", contentsType: ContentsType.Image, text: "", filePath: "/photos/test.jpg", createdDate: 2021, updatedDate: 2021)
    }
    
    struct DisplayedTag {
        static let displayedTags = [
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 1, name: "One", color: "#FF1D00"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 2, name: "Two", color: "#43FF5D"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 3, name: "Three", color: "#FF7016"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 4, name: "Four", color: "FFEE34"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 5, name: "Five", color: "#0823FF"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 6, name: "Six", color: "B72AFF")
        ]
    }
    
    struct TagFormFields {
        static let tagFormFields = [
            ManageTag.TagFormFields(id: 1, name: "One", color: "FF1D00", createdDate: "5050", description: "test")
        ]
    }

}
