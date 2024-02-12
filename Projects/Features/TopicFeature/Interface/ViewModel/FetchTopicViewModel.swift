//
//  FetchTopicViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine
import FeatureDependency

public struct FetchTopicQuery {
    
    public init(
        side: Topic.Side?,
        status: CurrentValueSubject<Topic.Progress, Never>?,
        keyword: Int?,
        pageInfo: Paging?,
        sort: String?
    ) {
        self.side = side
        self.status = status
        self.keyword = keyword
        self.pageInfo = pageInfo
        self.sort = sort
    }
    
    public let side: Topic.Side?
    public let status: CurrentValueSubject<Topic.Progress, Never>?
    public let keyword: Int?
    public var pageInfo: Paging?
    public let sort: String?
}

public protocol FetchTopicViewModel: BaseViewModel, ErrorHandleable {
    var topics: [TopicItemViewModel] { get set}
    var fetchTopicQuery: FetchTopicQuery { get set }
    var fetchTopicUseCase: any FetchTopicsUseCase { get }
    var reloadTopics: (() -> Void)? { get set }
    func fetchTopics()
    func fetchNextPage()
    func hasNextPage() -> Bool
}

extension FetchTopicViewModel {
    
    public func fetchTopics() {
        fetchTopicUseCase
            .execute(
                requestQuery: .init(
                    side: fetchTopicQuery.side,
                    status: fetchTopicQuery.status?.value,
                    keyword: fetchTopicQuery.keyword,
                    paging: fetchTopicQuery.pageInfo,
                    sort: fetchTopicQuery.sort)
            )
            .sink{ [weak self] result in
                guard let self = self, let (paging, topics) = result.data else { return }
                if result.isSuccess {
                    defer {
                        self.reloadTopics?()
                    }
                    self.fetchTopicQuery.pageInfo = paging
                    if paging.page == 0 {
                        self.topics = topics.map{ .init($0) }
                    }
                    else {
                        self.topics.append(contentsOf: topics.map{ .init($0) })
                    }
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    public func fetchNextPage() {
        
        updateNextPage()
        fetchTopics()
        
        func updateNextPage() {
            fetchTopicQuery.pageInfo?.page += 1
        }
    }
    
    public func hasNextPage() -> Bool {
        guard let pageInfo = fetchTopicQuery.pageInfo else { return false }
        return !pageInfo.last
    }
}
