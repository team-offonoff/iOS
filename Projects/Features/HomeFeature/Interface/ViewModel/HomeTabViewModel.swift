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

public protocol HomeTabViewModel: AnyObject, TopicPageControlViewModel, TimerControlViewModel, FetchTopicsViewModel, VoteTopicViewModel, RevoteTopicViewModel, TopicBottomSheetViewModel, FetchCommentPreviewViewModel, ErrorHandleable {
    var currentTopic: TopicDetailItemViewModel { get }
}

public protocol TopicPageControlViewModel {
    var topics: [Topic] { get }
    var canMovePrevious: Bool { get }
    var canMoveNext: Bool { get }
    var willMovePage: AnyPublisher<IndexPath, Never> { get }
    var reloadTopics: (() -> Void)? { get set }
    func moveNextTopic()
    func movePreviousTopic()
}

public protocol TimerControlViewModel{
    var timerSubject: PassthroughSubject<TimerInfo, Never> { get }
    func startTimer()
    func stopTimer()
}
