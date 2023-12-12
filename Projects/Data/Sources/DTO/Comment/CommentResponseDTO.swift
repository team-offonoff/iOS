//
//  CommentResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct CommentResponseDTO: Decodable {
    
    struct CommentWriterResponseDTO: Decodable {
        let id: Int
        let nickname: String
        let profileImageURl: String
    }
    
    let commentId: Int
    let topicId: Int
    let writer: CommentWriterResponseDTO
    let content: String
    let likes: Int
    let hates: Int
}
