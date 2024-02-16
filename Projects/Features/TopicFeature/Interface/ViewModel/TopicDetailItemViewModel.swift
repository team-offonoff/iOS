//
//  TopicDetailItemViewModel.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/08.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public struct TopicDetailItemViewModel {
    public let id: Int
    public let title: String
    public let nickname: String
    public let profileUrl: URL?
    public let side: String
    public let keyword: String
    public let deadline: Int?
    public let commentCount: String
    public let voteCount: String
    public var votedOption: Choice.Option?
    public let choices: [Choice.Option: Choice]
}

extension TopicDetailItemViewModel {
    
    public init(topic: Topic) {
        self.id = topic.id!
        self.title = topic.title
        self.nickname = topic.author?.nickname ?? ""
        self.profileUrl = topic.author?.profileImageUrl
        self.side = topic.side.title
        self.keyword = topic.keyword?.name ?? ""
        self.deadline = topic.deadline
        self.commentCount = ABFormat.count(topic.commentCount) + " 개"
        self.voteCount = ABFormat.count(topic.voteCount) + " 명"
        self.votedOption = topic.selectedOption
        self.choices = topic.choices
    }
    
    public var isVoted: Bool {
        votedOption != nil
    }
}

private extension Topic.Side {
    var title: String {
        switch self {
        case .A:    return "A 사이드"
        case .B:    return "B 사이드"
        }
    }
}
