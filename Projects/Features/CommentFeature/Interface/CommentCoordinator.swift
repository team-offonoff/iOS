//
//  CommentCoordinator.swift
//  CommentFeatureInterface
//
//  Created by 박소윤 on 2024/01/08.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain

public protocol CommentCoordinator: Coordinator {
    func startCommentBottomSheet(standard: CGFloat, topicId: Int, choices: [Choice])
    func startWritersBottomSheet(index: Int)
    func startOthersBottomSheet(index: Int)
}
