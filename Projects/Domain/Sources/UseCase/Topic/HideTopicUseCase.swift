//
//  HideTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2024/02/24.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation

public protocol HideTopicUseCase: UseCase {
    func execute(topicId: Int, request: HideTopicUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}

public final class DefaultHideTopicUseCase: HideTopicUseCase {

    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    public func execute(topicId: Int, request: HideTopicUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        repository.hide(topicId: topicId, request: request)
    }
}

public struct HideTopicUseCaseRequestValue {
    
    public init(memberId: Int) {
        self.memberId = memberId
    }
    
    public let memberId: Int
}
