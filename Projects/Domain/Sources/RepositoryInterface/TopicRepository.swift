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
    func fetchTopic(keywordId: Int?, paging: Paging?, sort: String?) -> NetworkResultPublisher<(Paging, [Topic])?>
    func report(topicId: Int) -> NetworkResultPublisher<Any?>
    func vote(topicId: Int, request: GenerateVoteUseCaseRequestValue) -> NetworkResultPublisher<Comment?>
    func revote(topicId: Int, request: RevoteUseCaseRequestValue) -> NetworkResultPublisher<Comment?>
}
