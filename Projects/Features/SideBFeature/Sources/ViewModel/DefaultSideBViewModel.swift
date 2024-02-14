//
//  DefaultSideBViewModel.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import SideBFeatureInterface
import TopicFeatureInterface
import FeatureDependency
import Domain
import Combine

final class DefaultSideBViewModel: BaseViewModel, SideBViewModel {
    
    init(fetchTopicUseCase: any FetchTopicsUseCase) {
        self.fetchTopicUseCase = fetchTopicUseCase
        super.init()
    }
    
    let keywords: [String] = ["전체", "AB Test", "카피라이팅", "UIUX", "커리어", "디자인", "개발"]
    
    var topics: [TopicItemViewModel] = []
    var fetchTopicQuery: FetchTopicQuery = .init(side: .B, status: CurrentValueSubject(.ongoing), keywordIdx: CurrentValueSubject(0), pageInfo: .init(page: 0, last: false), sort: nil)
    let fetchTopicUseCase: any FetchTopicsUseCase
    var reloadTopics: (() -> Void)?
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    override func bind() {

        bindQuery()
        
        func bindQuery() {
            
            guard let status = fetchTopicQuery.status, let keywordIdx = fetchTopicQuery.keywordIdx else { return }
            
            status
                .combineLatest(keywordIdx)
                .sink{ [weak self] _ in
                    defer {
                        self?.fetchTopics()
                    }
                    self?.fetchTopicQuery.pageInfo = .init(page: 0, last: false)
                }
                .store(in: &cancellable)
        }
    }
    
}
