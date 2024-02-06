//
//  TopicTagConfiguration.swift
//  ABKit
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit

public struct TopicTagConfiguration {
    let color: UIColor
    let title: String
}

extension TopicTag {
    var configuration: TopicTagConfiguration {
        switch self {
        case .competition:
            return .init(color: UIColor(r: 255, g: 82, b: 186), title: "치열한 경쟁 중")
        }
    }
}
