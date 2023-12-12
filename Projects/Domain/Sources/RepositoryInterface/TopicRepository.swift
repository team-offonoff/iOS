//
//  TopicRepository.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public protocol TopicRepository: Repository{
    func generateTopic(request: Topic) -> NetworkResultPublisher<Topic?>
    func fetchTopic() -> NetworkResultPublisher<[Topic]>
    func report(topicId: Int) -> NetworkResultPublisher<Any?>
    func vote(topicId: Int, request: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?>
    func cancelVote(topicId: Int, request: CancelVoteUseCaseRequestValue) -> NetworkResultPublisher<Any?>
}
