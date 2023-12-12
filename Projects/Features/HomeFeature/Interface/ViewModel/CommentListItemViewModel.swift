//
//  CommentListItemViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct CommentListItemViewModel {
    
    public init(
        profileImageUrl: URL,
        nickname: String,
        date: String,
        choice: String,
        content: String,
        likeCount: Int
    ) {
        self.profileImageUrl = profileImageUrl
        self.nickname = nickname
        self.date = date
        self.choice = choice
        self.content = content
        self.likeCount = String(likeCount)
    }
    
    public let profileImageUrl: URL
    public let nickname: String
    public let date: String
    public let choice: String
    public let content: String
    public let likeCount: String
}
