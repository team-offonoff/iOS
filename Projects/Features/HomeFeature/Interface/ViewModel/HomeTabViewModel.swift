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

public protocol HomeTabViewModel: TopicPageControllable, TimerControllable {
    var canBottomSheetMovePublisher: Published<Bool>.Publisher { get }
    func viewDidLoad()
}

public protocol TopicPageControllable {
    var topics: [Topic] { get }
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
