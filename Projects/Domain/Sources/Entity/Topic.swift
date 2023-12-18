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
    public let id: Int?
    public let side: Side
    public let title: String
    public let deadline: Int
    public let voteCount: Int?
    public let content: Any?
    public let keyword: Keyword
    public let choices: [Choice]
    public let author: Author?
    public let selectedOption: Choice.Option?
    
    public init(
        id: Int?,
        side: Topic.Side,
        title: String,
        deadline: Int,
        voteCount: Int?,
        content: Any? = nil,
        keyword: Keyword,
        choices: [Choice],
        author: Author?,
        selectedOption: Choice.Option?
    ) {
        self.id = id
        self.side = side
        self.title = title
        self.deadline = deadline
        self.voteCount = voteCount
        self.content = content
        self.keyword = keyword
        self.choices = choices
        self.author = author
        self.selectedOption = selectedOption
    }
}
