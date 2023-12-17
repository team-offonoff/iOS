//
//  DeleteCommentUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/17.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol DeleteCommentUseCase: UseCase {
    func execute(commentId: Int) -> NetworkResultPublisher<Any?>
}

public final class DefaultDeleteCommentUseCase: DeleteCommentUseCase {
    
    public typealias RepositoryInterface = CommentRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(commentId: Int) -> NetworkResultPublisher<Any?> {
        repository.deleteComment(commentId: commentId)
    }
}

