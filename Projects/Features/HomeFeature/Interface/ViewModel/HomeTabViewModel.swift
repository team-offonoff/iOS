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
import Core
import FeatureDependency

public protocol HomeTabViewModel: TopicPageControllableViewModel, TimerControllableViewModel, TopicChoiceableViewModel, TopicBottomSheetViewModel {
    func viewDidLoad()
}

public protocol TopicBottomSheetViewModel {
    var canChoiceReset: Bool { get }
    func hideTopic()
    func reportTopic()
    func resetChoice()
}

public protocol TopicChoiceableViewModel {
    var choiceSuccess: AnyPublisher<Choice, Never> { get }
    func choice(option: ChoiceOption)
}

public protocol TopicPageControllableViewModel {
    var topics: [HomeTopicItemViewModel] { get }
    var canMovePrevious: Bool { get }
    var canMoveNext: Bool { get }
    var willMovePage: Published<IndexPath>.Publisher { get }
    var reloadTopics: PassthroughSubject<Void, Never> { get }
    func moveNextTopic()
    func movePreviousTopic()
}

public protocol TimerControllableViewModel{
    var timerSubject: PassthroughSubject<TimerInfo, Never> { get }
    func startTimer()
    func stopTimer()
}
