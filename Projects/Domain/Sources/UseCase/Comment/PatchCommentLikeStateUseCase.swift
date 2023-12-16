//
//  PatchCommentLikeStateUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol PatchCommentLikeStateUseCase: UseCase {
    func execute(commentId: Int, isLike: Bool) -> NetworkResultPublisher<Any?>
}

public final class DefaultPatchCommentLikeStateUseCase: PatchCommentLikeStateUseCase {
    
    public typealias RepositoryInterface = CommentRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(commentId: Int, isLike: Bool) -> NetworkResultPublisher<Any?> {
        repository.patchLikeState(commentId: commentId, isLike: isLike)
    }
}
