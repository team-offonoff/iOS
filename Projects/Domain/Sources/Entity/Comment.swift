//
//  CommentEntity.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Comment {
    
    public let commentId: Int
    public let topicId: Int
    public let writer: WriterEntity
    public let votedOption: Choice.Option?
    public let content: String
    public let likeCount: Int
    public let hateCount: Int
    public let isLike: Bool
    public let isHate: Bool
    public let createdAt: Int
    
    public init(
        commentId: Int,
        topicId: Int,
        writer: Comment.WriterEntity,
        votedOption: Choice.Option? = nil,
        content: String,
        likeCount: Int,
        hateCount: Int,
        isLike: Bool,
        isHate: Bool,
        createdAt: Int
    ) {
        self.commentId = commentId
        self.topicId = topicId
        self.writer = writer
        self.votedOption = votedOption
        self.content = content
        self.likeCount = likeCount
        self.hateCount = hateCount
        self.isLike = isLike
        self.isHate = isHate
        self.createdAt = createdAt
    }

    public struct WriterEntity {
        
        public let id: Int
        public let nickname: String
        public let profileImageURl: URL?
        
        public init(
            id: Int,
            nickname: String,
            profileImageURl: URL?
        ) {
            self.id = id
            self.nickname = nickname
            self.profileImageURl = profileImageURl
        }
    }
}
