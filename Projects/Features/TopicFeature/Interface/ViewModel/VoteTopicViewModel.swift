//
//  VoteTopicViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain
import Combine
import Core

public protocol VoteTopicViewModel: BaseViewModel, ErrorHandleable {
    var topics: [Topic] { get set }
    var successVote: PassthroughSubject<(Index, Choice.Option), Never> { get }
    var failVote: PassthroughSubject<Index, Never> { get }
    var voteTopicUseCase: any GenerateVoteUseCase { get }
    func vote(_ option: Choice.Option, index: Int)
}

extension VoteTopicViewModel {
    public func vote(_ option: Choice.Option, index: Int) {
        voteTopicUseCase
            .execute(
                topicId: topics[index].id,
                request: .init(choiceOption: option, votedAt: UTCTime.current)
            )
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let (topic, comment) = result.data {
                    defer {
                        self.successVote.send((index, option))
                    }
                    self.topics[index] = topic
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
