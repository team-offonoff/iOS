//
//  TopicSide+Content.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2024/01/01.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

extension Topic.Side {
    public var content: ChoiceOptionContent {
        switch self {
        case .A:        return AChoiceOptionContent()
        case .B:        return BChoiceOptionContent()
        }
    }
}
