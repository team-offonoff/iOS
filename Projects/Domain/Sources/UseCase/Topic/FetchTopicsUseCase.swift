//
//  FetchTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/04.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol FetchTopicsUseCase: UseCase {
    func execute() -> NetworkResultPublisher<[Topic]>
}

public final class DefaultFetchTopicsUseCase: FetchTopicsUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute() -> NetworkResultPublisher<[Topic]> {
        repository.fetchTopic()
    }
    
}
