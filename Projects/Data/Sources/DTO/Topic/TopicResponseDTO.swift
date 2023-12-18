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
    let deadline: Int
    let voteCount: Int
    let topicContent: String?
    let keyword: KeywordResponseDTO
    let choices: [ChoiceResponseDTO]
    let author: AuthorResponseDTO
    let selectedOption: String?
    
    struct KeywordResponseDTO: Decodable {
        let keywordId: Int
        let keywordName: String
        let topicSide: String
    }
    
    struct ChoiceResponseDTO: Decodable {
        let choiceId: Int
        let content: ContentResponseDTO
        let choiceOption: String
        
        struct ContentResponseDTO: Decodable {
            let text: String
            let imageURL: String
            let type: String
        }
    }
    
    struct AuthorResponseDTO: Decodable {
        let id: Int
        let nickname: String
        let profileImageUrl: String?
    }
}

//MARK: Domainable

extension TopicResponseDTO: Domainable {
    
    func toDomain() -> Topic {
        .init(
            id: topicId,
            side: Mapper.entity(topicSide: topicSide),
            title: topicTitle,
            deadline: deadline,
            voteCount: voteCount,
            keyword: keyword.toDomain(),
            choices: choices.map{ $0.toDomain() },
            author: author.toDomain(),
            selectedOption: Mapper.entity(choiceOption: selectedOption)
        )
    }
}

extension TopicResponseDTO.KeywordResponseDTO: Domainable {
    func toDomain() -> Keyword {
        .init(
            id: keywordId,
            name: keywordName,
            topicSide: Mapper.entity(topicSide: topicSide)
        )
    }
}

extension TopicResponseDTO.ChoiceResponseDTO: Domainable {
    func toDomain() -> Choice {
        .init(
            id: choiceId,
            content: content.toDomain(),
            option: Mapper.entity(choiceOption: choiceOption)!
        )
    }
}

extension TopicResponseDTO.ChoiceResponseDTO.ContentResponseDTO: Domainable {
    func toDomain() -> Choice.Content {
        .init(
            text: text,
            imageURL: URL(string: imageURL)
        )
    }
}

extension TopicResponseDTO.AuthorResponseDTO: Domainable {
    func toDomain() -> Author {
        .init(
            id: id,
            nickname: nickname,
            profileImageUrl: URL(string: profileImageUrl ?? "")
        )
    }
}

