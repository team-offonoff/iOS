//
//  GenerateCommentUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol GenerateCommentUseCase: UseCase {
    func execute(request: GenerateCommentUseCaseRequestValue) -> NetworkResultPublisher<CommentEntity?>
}

public final class DefaultGenerateCommentUseCase: GenerateCommentUseCase {
    
    public typealias RepositoryInterface = CommentRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(request: GenerateCommentUseCaseRequestValue) -> NetworkResultPublisher<CommentEntity?> {
        repository.generateComment(request: request)
    }
}

public struct GenerateCommentUseCaseRequestValue {
    
    public init(topicId: Int, content: String) {
        self.topicId = topicId
        self.content = content
    }
    
    public let topicId: Int
    public let content: String
}
