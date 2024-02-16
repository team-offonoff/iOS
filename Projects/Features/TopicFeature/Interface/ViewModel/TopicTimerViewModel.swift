//
//  TopicTimerViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Combine

public protocol TopicTimerViewModel {
    var timerSubject: PassthroughSubject<TimerInfo, Never> { get }
    func startTimer()
    func stopTimer()
}
