//
//  Comment+Content.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension Comment.State {

    public var content: CommentStateContent {
        switch self {
        case .like:         return LikeCommentStateContent()
        case .dislike:      return DislikeCommentStateContent()
        default:            fatalError()
        }
    }
}

public protocol CommentStateContent {
    var defaultIcon: UIImage { get }
    var activateIcon: UIImage { get }
}

public struct LikeCommentStateContent: CommentStateContent {
    public let defaultIcon: UIImage = Image.chatLike
    public let activateIcon: UIImage = Image.chatLikeActivate
}

public struct DislikeCommentStateContent: CommentStateContent {
    public let defaultIcon: UIImage = Image.chatDislike
    public let activateIcon: UIImage = Image.chatDislikeActivate
}
