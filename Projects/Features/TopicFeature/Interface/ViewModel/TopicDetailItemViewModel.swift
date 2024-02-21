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
    public let isCommentEmpty: Bool
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
    public let isEnd: Bool
    public let isVoted: Bool
    public let winnerOption: Choice.Option?
    public let loserOption: Choice.Option?
    public let resultExplainText: String?
}

extension TopicDetailItemViewModel {
    
    public init(topic: Topic) {
        self.id = topic.id
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
        self.isCommentEmpty = topic.commentCount == 0
        self.isEnd = (topic.deadline ?? 0) < UTCTime.current
        self.isVoted = votedOption != nil
        self.winnerOption = .A
        self.loserOption = .B
        self.resultExplainText = winnerOption == topic.selectedOption ? "내가 고른 선택지가 이겼어요!" : "내가 고른 선택지가 아쉽게 떨어졌어요"
    }
    
    public func percentage(of option: Choice.Option) -> Int {
        switch option {
        case .A:        return aPercentage()
        case .B:        return 100 - aPercentage()
        }
        func aPercentage() -> Int {
            55
        }
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
