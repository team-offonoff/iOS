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
    
    struct WriterResponseDTO: Decodable {
        let id: Int
        let nickname: String
        let profileImageURl: String
    }
    
    let commentId: Int
    let topicId: Int
    let writer: WriterResponseDTO
    let content: String
    let likes: Int
    let hates: Int
}

extension CommentResponseDTO: Domainable {
    func toDomain() -> CommentEntity {
        .init(
            commentId: commentId,
            topicId: topicId,
            writer: writer.toDomain(),
            content: content,
            likes: likes,
            hates: hates
        )
    }
}

extension CommentResponseDTO.WriterResponseDTO: Domainable {
    func toDomain() -> CommentEntity.WriterEntity {
        .init(id: id, nickname: nickname, profileImageURl: URL(string: profileImageURl)!)
    }
}
