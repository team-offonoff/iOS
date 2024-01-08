//
//  HomeCoordinator.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain

public protocol HomeCoordinator: Coordinator {
    func startTopicBottomSheet()
    func startCommentBottomSheet(standard: CGFloat, topicId: Int, choices: [Choice])
    func startImagePopUp(choice: Choice)
}
