//
//  SideBViewModel.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import TopicFeatureInterface
import Combine

public protocol SideBViewModel: TopicBottomSheetViewModel, FetchTopicsViewModel, TopicTimerViewModel, VoteTopicViewModel, RevoteTopicViewModel {
    var keywords: [String] { get }
}
