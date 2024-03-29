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
    func generateTopic(request: GenerateTopicUseCaseRequestValue) async -> NetworkResultPublisher<Topic?>
    func fetchTopic(requestQuery: FetchTopicsUseCaseRequestQueryValue) -> NetworkResultPublisher<(Paging, [Topic])?>
    func hide(topicId: Int, request: HideTopicUseCaseRequestValue) -> NetworkResultPublisher<Any?>
    func report(topicId: Int) -> NetworkResultPublisher<Any?>
    func vote(topicId: Int, request: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<(Topic, Comment?)?>
    func revote(topicId: Int, request: RevoteUseCaseRequestValue) -> NetworkResultPublisher<(Topic, Comment?)?>
    func fetchCommentPreview(topicId: Int) -> NetworkResultPublisher<Comment?>
}
