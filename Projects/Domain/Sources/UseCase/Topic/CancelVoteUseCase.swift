//
//  CancelVoteUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol CancelVoteUseCase: UseCase {
    func execute(topicId: Int, request: CancelVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}

public final class DefaultCancelVoteUseCase: CancelVoteUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(topicId: Int, request: CancelVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        repository.cancelVote(topicId: topicId, request: request)
    }
}

public struct CancelVoteUseCaseRequestValue {
    
    public init(canceledAt: Int) {
        self.canceledAt = canceledAt
    }
    
    public let canceledAt: Int
}
