//
//  FetchTopicsViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine
import FeatureDependency
import Core

public struct FetchTopicsQuery {
    
    public init(
        side: Topic.Side?,
        status: CurrentValueSubject<Topic.Progress, Never>?,
        keywordIdx: CurrentValueSubject<Index, Never>?,
        pageInfo: Paging?,
        sort: String?
    ) {
        self.side = side
        self.status = status
        self.keywordIdx = keywordIdx
        self.pageInfo = pageInfo
        self.sort = sort
    }
    
    public let side: Topic.Side?
    public let status: CurrentValueSubject<Topic.Progress, Never>?
    public let keywordIdx: CurrentValueSubject<Index, Never>?
    public var pageInfo: Paging?
    public let sort: String?
}

public protocol FetchTopicsViewModel: BaseViewModel, ErrorHandleable {
    var topics: [Topic] { get set }
    var fetchTopicsQuery: FetchTopicsQuery { get set }
    var fetchTopicsUseCase: any FetchTopicsUseCase { get }
    var reloadTopics: (() -> Void)? { get set }
    func fetchTopics()
    func fetchNextPage()
    func hasNextPage() -> Bool
}

extension FetchTopicsViewModel {
    
    public func fetchTopics() {
        fetchTopicsUseCase
            .execute(
                requestQuery: .init(
                    side: fetchTopicsQuery.side,
                    status: fetchTopicsQuery.status?.value,
                    keyword: nil,//fetchTopicQuery.keywordIdx,
                    paging: fetchTopicsQuery.pageInfo,
                    sort: fetchTopicsQuery.sort)
            )
            .sink{ [weak self] result in
                guard let self = self, let (paging, topics) = result.data else { return }
                if result.isSuccess {
                    defer {
                        self.reloadTopics?()
                    }
                    self.fetchTopicsQuery.pageInfo = paging
                    if paging.page == 0 {
                        self.topics = topics
                    }
                    else {
                        self.topics.append(contentsOf: topics)
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
            fetchTopicsQuery.pageInfo?.page += 1
        }
    }
    
    public func hasNextPage() -> Bool {
        guard let pageInfo = fetchTopicsQuery.pageInfo else { return false }
        return !pageInfo.last
    }
}
