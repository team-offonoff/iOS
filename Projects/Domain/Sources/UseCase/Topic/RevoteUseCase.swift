//
//  RevoteUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol RevoteUseCase: UseCase {
    func execute(topicId: Int, request: RevoteUseCaseRequestValue) -> NetworkResultPublisher<(Topic, Comment?)?>
}

public final class DefaultRevoteUseCase: RevoteUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(topicId: Int, request: RevoteUseCaseRequestValue) -> NetworkResultPublisher<(Topic, Comment?)?> {
        repository.revote(topicId: topicId, request: request)
    }
}

public struct RevoteUseCaseRequestValue {
    
    public init(modifiedOption: Choice.Option, modifiedAt: Int) {
        self.modifiedOption = modifiedOption
        self.modifiedAt = modifiedAt
    }
    
    public let modifiedOption: Choice.Option
    public let modifiedAt: Int
}
