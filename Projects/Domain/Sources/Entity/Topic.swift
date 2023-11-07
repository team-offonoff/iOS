//
//  Topic.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public struct Topic {
    
    public init(
        id: Int? = nil,
        side: TopicSide,
        title: String,
        categoryId: Int,
        choices: [Choice],
        deadline: Int
    ){
        self.id = id
        self.side = side
        self.title = title
        self.categoryId = categoryId
        self.choices = choices
        self.deadline = deadline
    }
    
    public let id: Int?
    public let side: TopicSide
    public let title: String
    public let categoryId: Int
    public let choices: [Choice]
    public let deadline: Int
}
