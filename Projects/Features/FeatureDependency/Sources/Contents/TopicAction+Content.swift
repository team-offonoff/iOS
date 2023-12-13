//
//  TopicAction+Content.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/13.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension Topic.Action {

    public var content: TopicActionContent {
        switch self {
        case .hide:     return HideTopicActionContent()
        case .report:   return ReportTopicActionContent()
        case .reset:    return ResetTopicActionContent()
        default: fatalError()
        }
    }
}

public protocol TopicActionContent {
    var defaultIcon: UIImage { get }
    var disabledIcon: UIImage? { get }
    var title: String { get }
}

public struct HideTopicActionContent: TopicActionContent {
    public let defaultIcon: UIImage = Image.hide
    public let disabledIcon: UIImage? = nil
    public let title: String = "이런 토픽은 안볼래요"
}

public struct ReportTopicActionContent: TopicActionContent {
    public let defaultIcon: UIImage = Image.report
    public let disabledIcon: UIImage? = nil
    public let title: String = "신고하기"
}

public struct ResetTopicActionContent: TopicActionContent {
    public let defaultIcon: UIImage = Image.resetEnable
    public let disabledIcon: UIImage? = Image.resetDisable
    public let title: String = "투표 다시 하기"
}
