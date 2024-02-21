//
//  SideAViewModel.swift
//  SideAFeatureInterface
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine
import TopicFeatureInterface
import FeatureDependency

public typealias SideAViewModel = FetchTopicsViewModel & VoteTopicViewModel
