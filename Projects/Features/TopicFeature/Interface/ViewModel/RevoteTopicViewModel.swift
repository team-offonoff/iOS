//
//  RevoteTopicViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Combine
import Domain
import Core

public protocol RevoteTopicViewModel: BaseViewModel, ErrorHandleable {
    var topics: [TopicItemViewModel] { get set }
    var successVote: PassthroughSubject<(Index, Choice.Option), Never> { get }
    var failVote: PassthroughSubject<Index, Never> { get }
    var revoteTopicUseCase: any RevoteUseCase { get }
    func revote(_ option: Choice.Option, index: Int)
}

extension RevoteTopicViewModel {
    
    public func revote(_ option: Choice.Option, index: Int) {
        revoteTopicUseCase
            .execute(topicId: topics[index].id, request: .init(modifiedOption: option, modifiedAt: UTCTime.current))
            .sink{ [weak self] result in
                guard let self = self, let (topic, comment) = result.data  else { return }
                if result.isSuccess {
                    defer {
                        self.successVote.send((index, option))
                    }
                    self.topics[index] = .init(topic)
                    self.topics[index].commentPreview = comment
                }
                else {
                    if let error = result.error {
                        self.errorHandler.send(error)
                    }
                    self.failVote.send(index)
                }
            }
            .store(in: &cancellable)
    }
}
