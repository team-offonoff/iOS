//
//  TopicActionDelegate.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/13.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public protocol TopicActionDelegate: AnyObject {
    func action(_ action: Topic.Action)
}
