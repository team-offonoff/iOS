//
//  TopicGenerateCoordinator.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import FeatureDependency

public protocol TopicGenerateCoordinator: Coordinator {
    func startTopicGenerate()
}

