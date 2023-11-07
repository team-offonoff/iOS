//
//  TopicResponseDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

struct TopicResponseDTO: Decodable {
    let topicId: Int
    let topicSide: String
    let topicTitle: String
    let categoryId: Int
    let choices: [ChoiceResponseDTO]
    let deadline: Int
}

struct ChoiceResponseDTO: Decodable {
    
    struct ContentResponseDTO: Decodable {
        let text: String
        let imageURL: String
    }
    
    let choiceId: Int
    let content: ContentResponseDTO
    let choiceOption: String
}

//MARK: Domainable

extension TopicResponseDTO: Domainable {
    func toDomain() -> Topic {
        .init(
            id: topicId,
            side: TopicSide(rawValue: topicSide)!,
            title: topicTitle,
            categoryId: categoryId,
            choices: choices.map{ $0.toDomain() },
            deadline: deadline
        )
    }
}

extension ChoiceResponseDTO: Domainable {
    func toDomain() -> Choice {
        .init(
            id: choiceId,
            content: content.toDomain(),
            option: ChoiceOption(rawValue: choiceOption)!
        )
    }
}

extension ChoiceResponseDTO.ContentResponseDTO: Domainable {
    func toDomain() -> Choice.Content {
        .init(text: text, imageURL: URL(string: imageURL))
    }
}

