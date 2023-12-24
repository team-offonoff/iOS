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
    let likeCount: Int
    let hateCount: Int
    let liked: Bool
    let hated: Bool
    let createdAt: String
    
    struct WriterResponseDTO: Decodable {
        let id: Int
        let nickname: String
        let profileImageURl: String?
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
            likeCount: likeCount,
            hateCount: hateCount,
            isLike: liked,
            isHate: hated,
            createdAt: createdAt
        )
    }
}

extension CommentResponseDTO.WriterResponseDTO: Domainable {
    func toDomain() -> Comment.WriterEntity {
        .init(
            id: id,
            nickname: nickname,
            profileImageURl: URL(string: profileImageURl ?? "")
        )
    }
}
