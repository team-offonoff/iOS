//
//  PatchCommentDislikeStateUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol PatchCommentDislikeStateUseCase: UseCase {
    func execute(commentId: Int, isDislike: Bool) -> NetworkResultPublisher<Any?>
}

public final class DefaultPatchCommentDislikeStateUseCase: PatchCommentDislikeStateUseCase {
    
    public typealias RepositoryInterface = CommentRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(commentId: Int, isDislike: Bool) -> NetworkResultPublisher<Any?> {
        repository.patchDislikeState(commentId: commentId, isDislike: isDislike)
    }
}
