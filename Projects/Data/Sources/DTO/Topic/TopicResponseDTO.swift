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
        let content: ContentResponseDTO? //TODO: null 해제 필요
        let choiceOption: String
        
        struct ContentResponseDTO: Decodable {
            let text: String
            let imageUrl: String
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
            side: Topic.Side.toDomain(topicSide),
            title: topicTitle,
            deadline: deadline,
            voteCount: voteCount,
            keyword: keyword.toDomain(),
            choices: choices.map{ $0.toDomain() },
            author: author.toDomain(),
            selectedOption: Choice.Option.toDomain(selectedOption)
        )
    }
}

extension TopicResponseDTO.KeywordResponseDTO: Domainable {
    func toDomain() -> Keyword {
        .init(
            id: keywordId,
            name: keywordName,
            topicSide: Topic.Side.toDomain(topicSide)
        )
    }
}

extension TopicResponseDTO.ChoiceResponseDTO: Domainable {
    func toDomain() -> Choice {
        .init(
            id: choiceId,
            //TODO: null 해제 필요
            content: content?.toDomain() ?? .init(text: "choice is null", imageURL: nil),
            option: Choice.Option.toDomain(choiceOption)!
        )
    }
}

extension TopicResponseDTO.ChoiceResponseDTO.ContentResponseDTO: Domainable {
    func toDomain() -> Choice.Content {
        .init(
            text: text,
            imageURL: URL(string: imageUrl),
            type: type
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

