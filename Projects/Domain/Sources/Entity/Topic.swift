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
        id: Int?,
        side: Topic.Side,
        title: String,
        deadline: Int?,
        voteCount: Int,
        commentCount: Int,
        content: Any? = nil,
        keyword: Keyword?,
        choices: [Choice],
        author: Author?,
        createdAt: Int,
        selectedOption: Choice.Option?
    ) {
        self.id = id
        self.side = side
        self.title = title
        self.deadline = deadline
        self.voteCount = voteCount
        self.commentCount = commentCount
        self.content = content
        self.keyword = keyword
        self.choices = [
            .A: choices.first(where: { $0.option == .A })!,
            .B: choices.first(where: { $0.option == .B })!
        ]
        self.author = author
        self.createdAt = createdAt
        self.selectedOption = selectedOption
    }
    
    public let id: Int?
    public let side: Side
    public let title: String
    public let deadline: Int?
    public let voteCount: Int
    public let commentCount: Int
    public let content: Any?
    public let keyword: Keyword?
    public let choices: [Choice.Option: Choice]
    public let author: Author?
    public let createdAt: Int
    public let selectedOption: Choice.Option?
}
