//
//  FetchTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/04.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol FetchTopicsUseCase: UseCase {
    func execute(requestQuery: FetchTopicsUseCaseRequestQueryValue) -> NetworkResultPublisher<(Paging, [Topic])?>
}

public final class DefaultFetchTopicsUseCase: FetchTopicsUseCase {
    
    public typealias RepositoryInterface = TopicRepository
    
    private let repository: RepositoryInterface
    
    public init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    public func execute(requestQuery: FetchTopicsUseCaseRequestQueryValue) -> NetworkResultPublisher<(Paging, [Topic])?> {
        repository.fetchTopic(requestQuery: requestQuery)
    }
}

public struct FetchTopicsUseCaseRequestQueryValue {
    
    public init(
        side: Topic.Side?,
        status: Topic.Progress?,
        keyword: Int?,
        paging: Paging?,
        sort: String?
    ) {
        self.side = side
        self.status = status
        self.keyword = keyword
        self.paging = paging
        self.sort = sort
    }
    
    public let side: Topic.Side?
    public let status: Topic.Progress?
    public let keyword: Int?
    public let paging: Paging?
    public let sort: String?
}
