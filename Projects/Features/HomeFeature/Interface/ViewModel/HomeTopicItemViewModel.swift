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
        
        self.title = topic.title
        self.nickname = "닉네임"
        self.profileUrl = nil
        self.side = topic.side.title
        self.keyword = "대표 키워드" //topic.keyword
        self.deadline = topic.deadline
        self.chatCount = convertFormat(count: 1000) + " 개"
        self.likeCount = convertFormat(count: 1200) + " 명"
        self.aOption = topic.choices.first(where: { $0.option == .A })!
        self.bOption = topic.choices.first(where: { $0.option == .B })!
        self.votedChoice = nil
        
        func convertFormat(count: Int) -> String {
            //1. 999까지는 숫자 표현
            //2. 999 초과인 경우 '천' 단위 표기
            let (integer, decimal) = divide()
            if integer == 0 {
                return String(describing: count)
            }
            return (decimal == 0 ? String(describing: integer) : "\(integer).\(decimal)") + "천"
            
            //기준 단위에 맞춰 정수형과 소수점으로 구분한다.
            func divide(unit: Int = 1000) ->  (integer: Int, decimal: Int) {
                (count / unit, (count % unit)/(unit/10))
            }
        }
    }
    
    public var isVoted: Bool {
        votedChoice != nil
    }
}

private extension TopicSide {
    var title: String {
        switch self {
        case .A:    return "A 사이드"
        case .B:    return "B 사이드"
        }
    }
}
