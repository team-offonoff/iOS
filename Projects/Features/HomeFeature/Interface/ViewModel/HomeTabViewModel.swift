//
//  HomeTabViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Domain
import FeatureDependency

public protocol HomeTabViewModel: TopicPageControlViewModel, TimerControlViewModel, TopicVoteViewModel, TopicBottomSheetViewModel, ErrorHandleable {
    var currentTopic: HomeTopicItemViewModel { get }
    func viewDidLoad()
}

public protocol TopicBottomSheetViewModel {
    var successTopicAction: PassthroughSubject<Topic.Action, Never> { get }
    var canChoiceReset: Bool { get }
    func hideTopic()
    func reportTopic()
    func resetChoice()
}

public protocol TopicVoteViewModel {
    var voteSuccess: AnyPublisher<Choice, Never> { get }
    func vote(choice: Choice.Option)
}

public protocol TopicPageControlViewModel {
    var topics: [HomeTopicItemViewModel] { get }
    var canMovePrevious: Bool { get }
    var canMoveNext: Bool { get }
    var willMovePage: AnyPublisher<IndexPath, Never> { get }
    var reloadTopics: PassthroughSubject<Void, Never> { get }
    func moveNextTopic()
    func movePreviousTopic()
}

public protocol TimerControlViewModel{
    var timerSubject: PassthroughSubject<TimerInfo, Never> { get }
    func startTimer()
    func stopTimer()
}
