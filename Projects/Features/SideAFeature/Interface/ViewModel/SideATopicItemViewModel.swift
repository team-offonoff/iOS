//
//  SideATopicItemViewModel.swift
//  SideAFeatureInterface
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain

public struct SideATopicItemViewModel {
    
    public enum OptionState {
        case none
        case select
        case unselect
    }
    
    public init(topic: Topic) {
        
        self.id = topic.id!
        self.title = topic.title
        self.commentCount = "\(topic.commentCount)"
        self.votedOption = topic.selectedOption
        self.choices = [
            .A: convert(choice: topic.choices.first(where: { $0.option == .A })!),
            .B: convert(choice: topic.choices.first(where: { $0.option == .B })!)
        ]
        self.createdTime = 0
        
        func convert(choice: Choice) -> SideAChoiceItemViewModel {
            .init(id: choice.id, content: choice.content.text ?? "", voteCount: 0)
        }
    }
    
    public let id: Int
    public let title: String
    public let commentCount: String
    public let votedOption: Choice.Option?
    public let choices: [Choice.Option: SideAChoiceItemViewModel]
    private let createdTime: Int
    
    public var time: String {
        "방금"
    }
    
    public func tag() -> Topic.Tag? {
        switch percentage(of: .A) {
        case 51...55:       return .competition
        default:            return nil
        }
    }
    
    public func state(of option: Choice.Option) -> OptionState {
        guard let votedOption = votedOption else {
            return .none
        }
        return votedOption == option ? .select : .unselect
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
    
    public func content(of option: Choice.Option) -> String {
        switch state(of: option) {
        case .none:
            return choices[option]!.content
        case .select, .unselect:
            return choices[option]!.content + " (\(choices[option]!.voteCount)명)"
        }
    }
    
}

public struct SideAChoiceItemViewModel {
    
    public init(
        id: Int,
        content: String,
        voteCount: Int
    ) {
        self.id = id
        self.content = content
        self.voteCount = voteCount
    }
    
    public let id: Int
    public let content: String
    public let voteCount: Int
}
