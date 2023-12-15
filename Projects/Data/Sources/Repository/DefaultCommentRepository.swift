//
//  DefaultCommentRepository.swift
//  Data
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public final class DefaultCommentRepository: CommentRepository {

    private let networkService: NetworkService = NetworkService.shared
    private let basePath = "/comments"
    
    public init() { }
    
    public func generateComment(request: GenerateCommentUseCaseRequestValue) -> NetworkResultPublisher<Comment?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath
        
        guard let requestBody = try? JSONEncoder().encode(makeDTO()),
              let urlRequest = urlComponents?.toURLRequest(method: .post, httpBody: requestBody) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: CommentResponseDTO.self)
        
        func makeDTO() -> GenerateCommentRequestDTO{
            .init(topicId: request.topicId, content: request.content)
        }
    }
    
    public func fetchComments(topicId: Int, page: Int) -> NetworkResultPublisher<(Paging, [Comment])?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath
        urlComponents?.queryItems = [
            .init(name: "topic-id", value: String(topicId)),
            .init(name: "page", value: String(page)),
            .init(name: "size", value: String(50))
        ]
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .get) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest, responseType: PagingContentResponseDTO<CommentResponseDTO>.self)
    }
    
    public func patchLikeState(commentId: Int, isLike: Bool) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(commentId) + path("like")
        urlComponents?.queryItems = [
            .init(name: "enable", value: String(isLike))
        ]
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .post) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest)
    }
    
    public func patchDislikeState(commentId: Int, isDislike: Bool) -> NetworkResultPublisher<Any?> {
        
        var urlComponents = networkService.baseUrlComponents
        urlComponents?.path = basePath + path(commentId) + path("hate")
        urlComponents?.queryItems = [
            .init(name: "enable", value: String(isDislike))
        ]
        
        guard let urlRequest = urlComponents?.toURLRequest(method: .post) else {
            fatalError("json encoding or url parsing error")
        }
        
        return dataTask(request: urlRequest)
    }
    
    
}
