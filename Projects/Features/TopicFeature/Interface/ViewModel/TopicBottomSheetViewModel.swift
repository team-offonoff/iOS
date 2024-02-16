//
//  TopicBottomSheetViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine

public protocol TopicBottomSheetViewModel {
    var topicIndex: Int? { get set }
    var successTopicAction: PassthroughSubject<Topic.Action, Never> { get }
    var canRevote: Bool { get }
    func hideTopic(index: Int)
    func reportTopic(index: Int)
}
