//
//  TopicGenerateRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct TopicGenerateRequestDTO: Encodable {
    let topicSide: String
    let topicTitle: String
    let choices: [ChoiceGenerateRequestDTO]
    let deadline: Int
}

struct ChoiceGenerateRequestDTO: Encodable {
    let choiceOption: String
    let choiceContentRequest: ChoiceContentRequestModel
}

struct ChoiceContentRequestModel: Encodable {
    let type: String
    let imageUrl: String
    let text: String
}
