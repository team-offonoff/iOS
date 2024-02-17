//
//  CommentListItemViewModel.swift
//  CommentFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public struct CommentListItemViewModel {

    public init(
        _ comment: Comment, _ options: [Choice.Option: Choice]
    ) {
        self.id = comment.commentId
        self.isWriter = comment.writer.id == UserManager.shared.memberId
        self.writer = .init(id: comment.writer.id, nickname: comment.writer.nickname, profileImageUrl: comment.writer.profileImageURl)
        self.createdAt = comment.createdAt
        self.selectedOption = selectedOption()
        self.content = comment.content
        self.isLike = comment.isLike
        self.isHate = comment.isHate
        self.likeCount = comment.likeCount
        
        func selectedOption() -> (Choice.Option?, String) {
            guard let votedOption = comment.votedOption else {
                return (nil, "작성자")
            }
            return (votedOption, "\(votedOption.content.title).\(options[votedOption]!.content.text)")
        }
    }
    
    public let id: Int
    public let writer: WriterItemViewModel
    public let isWriter: Bool
    private let createdAt: Int
    ///option이 nil인 경우, 토픽 작성자를 의미한다
    public let selectedOption: (option: Choice.Option?, content: String)
    public let content: String
    public var isLike: Bool
    public var isHate: Bool
    public var likeCount: Int
    public var countOfLike: String {
        String(likeCount)
    }
    public var elapsedTime: String {
        UTCTime.elapsedTime(createdAt: createdAt)
    }
}

extension CommentListItemViewModel {
    public struct WriterItemViewModel{
        public let id: Int
        public let nickname: String
        public let profileImageUrl: URL?
    }
}
