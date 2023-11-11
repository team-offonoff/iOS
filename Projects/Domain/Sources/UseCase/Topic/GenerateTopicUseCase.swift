//
//  GenerateTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol GenerateTopicUseCase: UseCase {
    func execute(request: Topic) -> NetworkResultPublisher<Topic?>
}

public final class DefaultGenerateTopicUseCase: GenerateTopicUseCase {
    
    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    public func execute(request: Topic) -> NetworkResultPublisher<Topic?> {
        repository.generateTopic(request: request)
    }
}
