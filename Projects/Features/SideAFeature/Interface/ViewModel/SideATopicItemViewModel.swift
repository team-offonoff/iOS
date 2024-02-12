//
//  SideATopicItemViewModel.swift
//  SideAFeatureInterface
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import TopicFeatureInterface
import FeatureDependency
import Domain
import Core

public protocol SideATopicItemViewModel {
    var title: String { get }
    var commentCount: String { get }
    var isVoted: Bool { get }
    var elapsedTime: String { get }
    func tag() -> Topic.Tag?
    func state(of option: Choice.Option) -> OptionState
    func percentage(of option: Choice.Option) -> Int
    func content(of option: Choice.Option) -> String
}

extension TopicItemViewModel: SideATopicItemViewModel {

    public var title: String {
        topic.title
    }
    public var id: Int {
        topic.id!
    }
    public var commentCount: String {
        "\(topic.commentCount)"
    }
    
    public var isVoted: Bool {
        topic.selectedOption != nil
    }
    
    public var elapsedTime: String {
        UTCTime.elapsedTime(createdAt: topic.createdAt)
    }
    
    public func tag() -> Topic.Tag? {
        switch percentage(of: .A) {
        case 51...55:       return .competition
        default:            return nil
        }
    }
    
    public func state(of option: Choice.Option) -> OptionState {
        guard let votedOption = topic.selectedOption else {
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
            return topic.choices[option]!.content.text ?? ""
        case .select, .unselect:
            return topic.choices[option]!.content.text ?? "" //+ " (\(choices[option]!.voteCount)명)"
        }
    }
    
}

public enum OptionState {
    case none
    case select
    case unselect
}
