//
//  VoteResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

struct VoteResponseDTO: Decodable {
    let latestComment: CommentResponseDTO?
    let topic: TopicResponseDTO
}

extension VoteResponseDTO: Domainable {
    func toDomain() -> (Topic, Comment?) {
        (topic.toDomain(), latestComment?.toDomain())
    }
}
