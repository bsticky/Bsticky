//
//  ManagedSticky.swift
//  bSticky
//
//  Created by mima on 2021/03/06.
//  Copyright © 2021 FiftyPercent. All rights reserved.
//

struct ManagedSticky: Equatable {
    var id: Int
    var tagColor: String
    var tagName: String
    var contentsType: ContentsType
    var text: String
    var fileName: String
    var createdDate: Int
    var updatedDate: Int
}

func ==(lhs: ManagedSticky, rhs: ManagedSticky) -> Bool {
    return lhs.id == rhs.id
        && lhs.tagColor == rhs.tagColor
        && lhs.tagName == rhs.tagName
        && lhs.contentsType.rawValue == rhs.contentsType.rawValue
        && lhs.text == rhs.text
        && lhs.fileName == rhs.fileName
        && lhs.createdDate == rhs.createdDate
        && lhs.updatedDate == rhs.updatedDate
}
