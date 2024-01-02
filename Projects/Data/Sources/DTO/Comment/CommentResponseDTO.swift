//
//  CommentResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct CommentResponseDTO: Decodable {
    
    let commentId: Int
    let topicId: Int
    let writer: WriterResponseDTO
    let writersVotedOption: String?
    let content: String
    let commentReaction: ReactionResponseDTO
    let createdAt: Int
    
    struct WriterResponseDTO: Decodable {
        let id: Int
        let nickname: String
        let profileImageUrl: String?
    }
    
    struct ReactionResponseDTO: Decodable {
        let likeCount: Int
        let hateCount: Int
        let liked: Bool
        let hated: Bool
    }
}

extension CommentResponseDTO: Domainable {
    func toDomain() -> Comment {
        .init(
            commentId: commentId,
            topicId: topicId,
            writer: writer.toDomain(),
            votedOption: Choice.Option.toDomain(writersVotedOption),
            content: content,
            likeCount: commentReaction.likeCount,
            hateCount: commentReaction.hateCount,
            isLike: commentReaction.liked,
            isHate: commentReaction.hated,
            createdAt: createdAt
        )
    }
}

extension CommentResponseDTO.WriterResponseDTO: Domainable {
    func toDomain() -> Comment.WriterEntity {
        .init(
            id: id,
            nickname: nickname,
            profileImageURl: URL(string: profileImageUrl ?? "")
        )
    }
}
