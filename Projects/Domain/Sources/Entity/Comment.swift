//
//  CommentEntity.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct Comment {

    public init(
        commentId: Int,
        topicId: Int,
        writer: Comment.WriterEntity,
        content: String,
        likes: Int,
        hates: Int
    ) {
        self.commentId = commentId
        self.topicId = topicId
        self.writer = writer
        self.content = content
        self.likes = likes
        self.hates = hates
    }
    
    public struct WriterEntity {
        
        public init(
            id: Int,
            nickname: String,
            profileImageURl: URL
        ) {
            self.id = id
            self.nickname = nickname
            self.profileImageURl = profileImageURl
        }
        
        public let id: Int
        public let nickname: String
        public let profileImageURl: URL
    }
    
    public let commentId: Int
    public let topicId: Int
    public let writer: WriterEntity
    public let content: String
    public let likes: Int
    public let hates: Int
}
