//
//  PatchCommentUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/02.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol PatchCommentUseCase: UseCase {
    func execute(commentId: Int, request: PatchCommentUseCaseRequestValue) -> NetworkResultPublisher<Comment?>
}

public final class DefaultPatchCommentUseCase: PatchCommentUseCase {
    
    private let repository: CommentRepository
    
    public init(repository: CommentRepository) {
        self.repository = repository
    }
    
    public func execute(commentId: Int, request: PatchCommentUseCaseRequestValue) -> NetworkResultPublisher<Comment?> {
        repository.patchComment(commentId: commentId, request: request)
    }
}

public struct PatchCommentUseCaseRequestValue {
    
    public init(content: String) {
        self.content = content
    }
    
    public let content: String
}
