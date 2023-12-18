//
//  HomeTopicItemViewModel.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/02.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public struct HomeTopicItemViewModel {
    public let id: Int
    public let title: String
    public let nickname: String
    public let profileUrl: URL?
    public let side: String
    public let keyword: String
    public let deadline: Int
    public let chatCount: String
    public let likeCount: String
    public let aOption: Choice
    public let bOption: Choice
    public var votedChoice: Choice?
}

extension HomeTopicItemViewModel {
    
    public init(topic: Topic) {
        self.id = topic.id!
        self.title = topic.title
        self.nickname = "닉네임"
        self.profileUrl = nil
        self.side = topic.side.title
        self.keyword = "대표 키워드" //topic.keyword
        self.deadline = topic.deadline
        self.chatCount = ABFormat.count(1000) + " 개"
        self.likeCount = ABFormat.count(1200) + " 명"
        self.aOption = topic.choices.first(where: { $0.option == .A })!
        self.bOption = topic.choices.first(where: { $0.option == .B })!
        self.votedChoice = nil
    }
    
    public var isVoted: Bool {
        votedChoice != nil
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
