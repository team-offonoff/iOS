//
//  FetchCommentsUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol FetchCommentsUseCase: UseCase {
    func execute(topicId: Int, page: Int) -> NetworkResultPublisher<(PageEntity, [CommentEntity])?>
}

public final class DefaultFetchCommentsUseCase: FetchCommentsUseCase {
    
    public typealias RepositoryInterface = CommentRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(topicId: Int, page: Int) -> NetworkResultPublisher<(PageEntity, [CommentEntity])?> {
        repository.fetchComments(topicId: topicId, page: page)
    }
}
