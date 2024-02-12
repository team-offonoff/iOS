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
        fetchTopicUseCase: any FetchTopicsUseCase,
        voteTopicUseCase: any GenerateVoteUseCase
    ) {
        self.fetchTopicUseCase = fetchTopicUseCase
        self.voteTopicUseCase = voteTopicUseCase
    }
    
    let fetchTopicUseCase: any FetchTopicsUseCase
    let voteTopicUseCase: any GenerateVoteUseCase
    
    var topics: [TopicItemViewModel] = []
    var reloadTopics: (() -> Void)?
    var fetchTopicQuery: FetchTopicQuery = FetchTopicQuery(
        side: Topic.Side.A,
        status: CurrentValueSubject(.ongoing),
        keyword: nil,
        pageInfo: Paging(page: 0, last: false),
        sort: nil
    )
    
    let successVote: PassthroughSubject<(Index, Choice.Option), Never> = PassthroughSubject()
    let failVote: PassthroughSubject<Index, Never> = PassthroughSubject()
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    override func bind() {
        fetchTopicQuery.status?
            .sink{ [weak self] _ in
                defer {
                    self?.fetchTopics()
                }
                self?.fetchTopicQuery.pageInfo = .init(page: 0, last: false)
            }
            .store(in: &cancellable)
    }
}
 
