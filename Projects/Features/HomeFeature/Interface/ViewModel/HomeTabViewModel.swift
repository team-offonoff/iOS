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
import TopicFeatureInterface
import FeatureDependency

public protocol HomeTabViewModel: AnyObject, TopicPageControlViewModel, TimerControlViewModel, TopicVoteViewModel, TopicBottomSheetViewModel, ErrorHandleable {
    var currentTopic: TopicDetailItemViewModel { get }
    func viewDidLoad()
}

public protocol TopicVoteViewModel {
    var successVote: PassthroughSubject<Choice.Option, Never> { get }
    var failVote: PassthroughSubject<Void, Never> { get }
    func vote(_ option: Choice.Option)
    func revote(_ option: Choice.Option)
}

public protocol TopicPageControlViewModel {
    var topics: [TopicDetailItemViewModel] { get }
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
