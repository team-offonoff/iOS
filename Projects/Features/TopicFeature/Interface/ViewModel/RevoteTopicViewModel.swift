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
    var topics: [Topic] { get set }
    var successVote: PassthroughSubject<(Index, Choice.Option), Never> { get }
    var failVote: PassthroughSubject<Index, Never> { get }
    var revoteTopicUseCase: any RevoteUseCase { get }
    func revote(_ option: Choice.Option, index: Int)
}

extension RevoteTopicViewModel {
    
    public func revote(_ option: Choice.Option, index: Int) {
        
        //이전과 동일한 선택지로 재투표할 경우, API를 요청하지 않는다.
        if topics[index].selectedOption == option {
            successVote.send((index, option))
            return
        }
        
        revoteTopicUseCase
            .execute(topicId: topics[index].id, request: .init(modifiedOption: option, modifiedAt: UTCTime.current))
            .sink{ [weak self] result in
                guard let self = self, var (topic, comment) = result.data  else { return }
                if result.isSuccess {
                    defer {
                        self.successVote.send((index, option))
                    }
                    topic.commentPreview = comment
                    self.topics[index] = topic
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
