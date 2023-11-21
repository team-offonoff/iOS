//
//  GenerateCategoryUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/21.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol GenerateCategoryUseCase: UseCase {
    func execute(request: GenerateCategoryUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}

public final class DefaultGenerateCategoryUseCase: GenerateCategoryUseCase {
    
    private let repository: CategoryRepository
    
    public init(repository: CategoryRepository) {
        self.repository = repository
    }
    
    public func execute(request: GenerateCategoryUseCaseRequestValue) -> NetworkResultPublisher<Any?> {
        repository.generateCategory(request: request)
    }
}

public struct GenerateCategoryUseCaseRequestValue {
    public let name: String
    public let topicSide: TopicSide
}
