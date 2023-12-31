//
//  ReportTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/06.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol ReportTopicUseCase: UseCase {
    func execute(topicId: Int) -> NetworkResultPublisher<Any?>
}

public final class DefaultReportTopicUseCase: ReportTopicUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(topicId: Int) -> NetworkResultPublisher<Any?> {
        repository.report(topicId: topicId)
    }
    
}
