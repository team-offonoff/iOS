//
//  LatestCommentResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

struct LatestCommentResponseDTO: Decodable {
    let latestComment: CommentResponseDTO
}

extension LatestCommentResponseDTO: Domainable {
    func toDomain() -> Comment {
        latestComment.toDomain()
    }
}
