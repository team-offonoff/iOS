//
//  DefaultTopicRepository.swift
//  Data
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public final class DefaultTopicRepository: TopicRepository {
    
    private let networkService: NetworkService = NetworkService.shared
    private let basePath = "/topics"
    
    public init() { }
    
    public func generateTopic(request: Topic) -> NetworkResultPublisher<Topic?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()),
              let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: TopicResponseDTO.self)
        
        func makeDTO() -> TopicGenerateRequestDTO {
            .init(
                topicSide: request.side.rawValue,
                categoryId: request.categoryId,
                topicTitle: request.title,
                choices: makeChoiceDTO(),
                deadline: request.deadline
            )
        }
        
        func makeChoiceDTO() -> [ChoiceGenerateRequestDTO] {
            request.choices.map{ choice in
                    .init(
                        choiceOption: choice.option.rawValue,
                        choiceContentRequest: .init(
                            type: "IMAGE_TEXT",
                            imageUrl: String(describing: choice.content.imageURL),
                            text: choice.content.text
                        )
                    )
            }
        }
    }
    
    //임시 구현
    public func fetchTopic() -> NetworkResultPublisher<[Topic]> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .get) else {
            fatalError("json encoding or url parsing error")
        }
        
        return arrayDataTask(request: urlRequest, elementType: TopicResponseDTO.self)
    }
    
    public func report(topicId: Int) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(topicId) + path("report")
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .post) else {
            fatalError("url parsing error")
        }

        return dataTask(request: urlRequest)
    }
}
