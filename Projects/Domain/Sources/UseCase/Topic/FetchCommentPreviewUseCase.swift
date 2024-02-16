//
//  FetchCommentPreviewUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol FetchCommentPreviewUseCase: UseCase {
    func execute(topicId: Int) -> NetworkResultPublisher<Comment?>
}

public final class DefaultFetchCommentPreviewUseCase: FetchCommentPreviewUseCase {

    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    public func execute(topicId: Int) -> NetworkResultPublisher<Comment?> {
        repository.fetchCommentPreview(topicId: topicId)
    }
}
