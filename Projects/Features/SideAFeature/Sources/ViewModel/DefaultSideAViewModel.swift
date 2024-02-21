//
//  DefaultSideAViewModel.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import SideAFeatureInterface
import TopicFeatureInterface
import FeatureDependency
import Domain
import Combine
import Core

final class DefaultSideAViewModel: BaseViewModel, SideAViewModel {
    
    init(
        fetchTopicsUseCase: any FetchTopicsUseCase,
        voteTopicUseCase: any GenerateVoteUseCase
    ) {
        self.fetchTopicsUseCase = fetchTopicsUseCase
        self.voteTopicUseCase = voteTopicUseCase
    }
    
    let fetchTopicsUseCase: any FetchTopicsUseCase
    let voteTopicUseCase: any GenerateVoteUseCase
    
    var topics: [Topic] = []
    var reloadTopics: (() -> Void)?
    var fetchTopicsQuery: FetchTopicsQuery = FetchTopicsQuery(
        side: Topic.Side.A,
        status: CurrentValueSubject(.ongoing),
        keywordIdx: nil,
        pageInfo: Paging(page: 0, last: false),
        sort: "createdAt,desc"
    )
    
    let successVote: PassthroughSubject<(Index, Choice.Option), Never> = PassthroughSubject()
    let failVote: PassthroughSubject<Index, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    override func bind() {
        fetchTopicsQuery.status?
            .sink{ [weak self] _ in
                defer {
                    self?.fetchTopics()
                }
                self?.fetchTopicsQuery.pageInfo = .init(page: 0, last: false)
            }
            .store(in: &cancellable)
    }
}
 
