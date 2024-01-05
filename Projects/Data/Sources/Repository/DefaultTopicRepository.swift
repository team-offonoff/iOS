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
import Combine

public final class DefaultTopicRepository: TopicRepository {
    
    private let networkService: NetworkService = NetworkService.shared
    private let basePath = "/topics"
    private let presignedImageRepository: PresignedImageRepository = DefaultPresignedImageRepository()
    
    public init() { }
    
    public func generateTopic(request: GenerateTopicUseCaseRequestValue) async -> NetworkResultPublisher<Topic?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath
        
        do {
            let dto = try await makeDTO()
            guard let requestBody = try? JSONEncoder().encode(dto),
                  let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
                fatalError("json encoding or url parsing error")
            }
            return dataTask(request: urlRequest, responseType: TopicResponseDTO.self)
        }
        catch ABError.imageUpload {
            print("image upload 실패")
            return Just((false, nil, nil)).eraseToAnyPublisher()
        }
        catch {
            fatalError()
        }
        
        func makeDTO() async throws -> TopicGenerateRequestDTO {
            .init(
                side: request.side.toDTO(),
                keywordName: request.keyword,
                title: request.title,
                choices: try await makeChoicesDTO(),
                deadline: request.deadline
            )
        }
        
        func makeChoicesDTO() async throws -> [TopicGenerateRequestDTO.ChoiceRequestDTO] {
            let images = request.choices.compactMap{ $0.image }
            var url = [String?](repeating: nil, count: request.choices.count)
            if !images.isEmpty {
                for (i,image) in images.enumerated() {
                    url[i] = try await presignedImageRepository.upload(bucket: .topic, request: image)
                }
            }
            
            return request.choices.enumerated()
                .map{ i, choice in
                        .init(
                            choiceOption: choice.option.toDTO(),
                            choiceContentRequest: .init(
                                type: "IMAGE_TEXT",
                                imageUrl: url[i],
                                text: choice.text
                            )
                        )
                }
        }
    }
    
    public func fetchTopic(keywordId: Int?, paging: Paging?, sort: String?) -> NetworkResultPublisher<(Paging, [Topic])?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path("info") + path("voting")
//        urlComponents?.queryItems = [
//            .init(name: "keywordId", value: keywordId),
//            .init(name: "page", value: <#T##String?#>),
//            .init(name: "size", value: <#T##String?#>),
//            .init(name: "sort", value: sort)
//
//        ]
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .get) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: PagingContentResponseDTO<TopicResponseDTO>.self)
    }
    
    public func report(topicId: Int) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(topicId) + path("report")
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .post) else {
            fatalError("url parsing error")
        }

        return dataTask(request: urlRequest)
    }
    
    public func vote(topicId: Int, request: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(topicId) + path("vote")
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()),
              let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("json encoding or url parsing error")
        }
    
        return dataTask(request: urlRequest)
        
        func makeDTO() -> GenerateVoteRequestDTO {
            .init(
                choiceOption: request.choiceOption.toDTO(),
                votedAt: request.votedAt)
        }
    }
    
    public func cancelVote(topicId: Int, request: CancelVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(topicId) + path("vote")
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()),
              let urlRequest = urlComponents?.toURLRequest(method: .delete, httpBody: requestBody) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest)
        
        func makeDTO() -> CancelVoteRequestDTO {
            .init(canceledAt: request.canceledAt)
        }
        
    }
}
