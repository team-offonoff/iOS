//
//  SideACoordinator.swift
//  SideAFeatureInterface
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain

public protocol SideACoordinator: Coordinator {
    func startCommentBottomSheet(topicId: Int, choices: [Choice.Option: Choice])
}

