//
//  Seeds.swift
//  bStickyTests
//
//  Created by mima on 2021/07/29.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

@testable import bSticky
import XCTest

struct Seeds {
    struct Tags {
        static let tagOne = Tag(id: 1, name: "tagOne", color: "#FFFFFF", position: 1, activated: true, createdDate: 1627512117, description: "tagOne|id: 0|position: 1")
        static let tagTwo = Tag(id: 2, name: "tagTwo", color: "#000000", position: 2, activated: true, createdDate: 1627512654 , description: "tagTwo|id: 1|position:2")
    }
    
    // For test StartBeeViewController: displayFetchedTags()
    struct DisplayedTags {
        static let displayedTags = [
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 1, name: "TagOne", color: "#FF1D00"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 2, name: "TagTwo", color: "#43FF5D"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 3, name: "TagThree", color: "#FF7016"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 4, name: "TagFour", color: "FFEE34"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 5, name: "TagFive", color: "#0823FF"),
            StartBee.FetchTags.ViewModel.DisplayedTag(id: 6, name: "TagSix", color: "B72AFF")
        ]
    }
}

