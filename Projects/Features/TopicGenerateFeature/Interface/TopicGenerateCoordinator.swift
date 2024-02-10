//
//  TopicGenerateCoordinator.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import UIKit
import Domain

public protocol TopicGenerateCoordinator: Coordinator {
    func startTopicGenerate()
    func startBsideTopicGenerate()
    func startPopUp(option: Choice.Option,image: UIImage)
}

