//
//  Bsticky.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

struct Sticky: Equatable {
    var id: Int
    var tagId: Int
    var tagColor: String
    var contentsType: ContentsType
    var text: String
    var filePath: String
    var createdDate: Int
    var updatedDate: Int
}

func ==(lhs: Sticky, rhs: Sticky) -> Bool {
    return lhs.id == rhs.id
        && lhs.tagId == rhs.tagId
        && lhs.contentsType == rhs.contentsType
        && lhs.text == rhs.text
        && lhs.filePath == rhs.filePath
        && lhs.createdDate == rhs.createdDate
        && lhs.updatedDate == rhs.updatedDate
}

enum ContentsType: Int {
    case Text = 1
    case Image = 2
    case Audio = 3
    case Video = 4
}

func ==(lhs: ContentsType, rhs:ContentsType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
