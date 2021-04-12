//
//  Btag.swift
//  bSticky
//
//  Created by mima on 14/12/2020.
//  Copyright © 2020 FiftyPercent. All rights reserved.
//

import Foundation

struct Tag: Equatable {
    var id: Int
    var name: String
    var color: String
    var position: Int
    var activated: Bool
    var createdDate: Int
    var description: String?
}

func ==(lhs: Tag, rhs: Tag) -> Bool {
    return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.color == rhs.color
        && lhs.createdDate == rhs.createdDate
        && lhs.description == rhs.description
}
