//
//  TopicProgress+Configuration.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

public struct TopicProgressConfiguration {
    public let title: String
}

extension Topic.Progress {
    public var configuration: TopicProgressConfiguration {
        switch self {
        case .ongoing:      return .init(title: "진행중")
        case .termination:  return .init(title: "종료된")
        }
    }
}
