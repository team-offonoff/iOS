//
//  FetchTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/04.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol FetchTopicsUseCase: UseCase {
    func execute(keywordId: Int?, paging: Paging?, sort: String?) -> NetworkResultPublisher<(Paging, [Topic])?>
}

public final class DefaultFetchTopicsUseCase: FetchTopicsUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(keywordId: Int? = nil, paging: Paging?, sort: String? = nil) -> NetworkResultPublisher<(Paging, [Topic])?> {
        repository.fetchTopic(keywordId: keywordId, paging: paging, sort: sort)
    }
    
}
