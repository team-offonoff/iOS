//
//  HomeCoordinator.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import FeatureDependency

public protocol HomeCoordinator: Coordinator {
    func startTopicBottomSheet()
    func startChatBottomSheet()
}
