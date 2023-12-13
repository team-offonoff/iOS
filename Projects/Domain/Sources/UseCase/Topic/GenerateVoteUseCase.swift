//
//  GenerateVoteUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol GenerateVoteUseCase: UseCase {
    func execute(topicId: Int, request: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}

public final class DefaultGenerateVoteUseCase: GenerateVoteUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(topicId: Int, request choice: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        repository.vote(topicId: topicId, request: choice)
    }
}

public struct GenerateVoteUseCaseRequestValue {
    
    public init(choiceOption: Choice.Option, votedAt: Int) {
        self.choiceOption = choiceOption
        self.votedAt = votedAt
    }
    
    public let choiceOption: Choice.Option
    public let votedAt: Int
}
