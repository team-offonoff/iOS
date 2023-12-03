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

public protocol HomeTabViewModel: TopicPageControllable, TimerControllable, TopicSelectable, TopicBottomSheetViewModel {
    func viewDidLoad()
}

public protocol TopicBottomSheetViewModel {
    var canChoiceReset: Bool { get }
    func hideTopic()
    func reportTopic()
    func resetChoice()
}

public protocol TopicSelectable {
    var selectionSuccess: AnyPublisher<Choice, Never> { get }
    func select(option: ChoiceOption)
}

public protocol TopicPageControllable {
    var topics: [HomeTopicItemViewModel] { get }
    var canMovePrevious: Bool { get }
    var canMoveNext: Bool { get }
    var willMovePage: Published<IndexPath>.Publisher { get }
    var reloadTopics: PassthroughSubject<Void, Never> { get }
    func moveNextTopic()
    func movePreviousTopic()
}

public protocol TimerControllable{
    var timerSubject: PassthroughSubject<TimerInfo, Never> { get }
    func startTimer()
    func stopTimer()
}
