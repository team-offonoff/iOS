//
//  BottomSheetAction+Content.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/17.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

//MARK: - Topic

extension Topic.Action: BottomSheetAction {

    public var content: BottomSheetActionContent {
        switch self {
        case .hide:     return HideTopicActionContent()
        case .report:   return ReportTopicActionContent()
        case .revote:    return ResetTopicActionContent()
        default: fatalError()
        }
    }
}

public struct HideTopicActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.hide
    public let disabledIcon: UIImage? = nil
    public let title: String = "이런 토픽은 안볼래요"
}

public struct ReportTopicActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.report
    public let disabledIcon: UIImage? = nil
    public let title: String = "신고하기"
}

public struct ResetTopicActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.resetEnable
    public let disabledIcon: UIImage? = Image.resetDisable
    public let title: String = "투표 다시 하기"
}



//MARK: - Comment

extension Comment.Action: BottomSheetAction {
    
    public var content: BottomSheetActionContent {
        switch self {
        case .report:     return ReportCommentActionContent()
        case .modify:     return ModifyCommentActionContent()
        case .delete:     return DeleteCommentActionContent()
        default: fatalError()
        }
    }
}

public struct ReportCommentActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.report
    public let disabledIcon: UIImage? = nil
    public let title: String = "신고"
}

public struct ModifyCommentActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.modify
    public let disabledIcon: UIImage? = nil
    public let title: String = "수정"
}

public struct DeleteCommentActionContent: BottomSheetActionContent {
    public let defaultIcon: UIImage = Image.delete
    public let disabledIcon: UIImage? = nil
    public let title: String = "삭제"
}
