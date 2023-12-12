//
//  GenerateCommentRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

struct GenerateCommentRequestDTO: Encodable {
    let topicId: Int
    let content: String
}
