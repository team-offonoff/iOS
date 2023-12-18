//
//  Keyword.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/18.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Keyword {
    public let id: Int?
    public let name: String
    public let topicSide: Topic.Side
    
    public init(
        id: Int?,
        name: String,
        topicSide: Topic.Side
    ) {
        self.id = id
        self.name = name
        self.topicSide = topicSide
    }
}
