//
//  CommentListItemViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public struct CommentListItemViewModel {

    public init(
        comment: Comment
    ) {
        self.profileImageUrl = comment.writer.profileImageURl
        self.nickname = comment.writer.nickname
        self.date = "" //comment.date
        self.choice = "" //comment.choice
        self.content = comment.content
        self.likeCount = String(comment.likes)
    }
    
    public let profileImageUrl: URL
    public let nickname: String
    public let date: String
    public let choice: String
    public let content: String
    public let likeCount: String
}
