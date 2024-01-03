//
//  CommentListItemViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public struct CommentListItemViewModel {

    public init(
        _ comment: Comment, _ options: [Choice]
    ) {
        self.id = comment.commentId
        self.profileImageUrl = comment.writer.profileImageURl
        self.nickname = comment.writer.nickname
        self.createdAt = comment.createdAt
        self.selectedOption = selectedOption()
        self.content = comment.content
        self.isLike = comment.isLike
        self.isHate = comment.isHate
        self.likeCount = comment.likeCount
        
        func selectedOption() -> (Choice.Option?, String) {
            guard let option = comment.votedOption else {
                return (nil, "작성자")
            }
            return (option, "\(option.content.title).\(options.filter{ $0.option == comment.votedOption }.first!.content.text)")
        }
    }
    
    public let id: Int
    public let profileImageUrl: URL?
    public let nickname: String
    private let createdAt: Int
    ///option이 nil인 경우, 토픽 작성자를 의미한다
    public let selectedOption: (option: Choice.Option?, content: String)
    public let content: String
    public var isLike: Bool
    public var isHate: Bool
    public var likeCount: Int
    public var likeCountString: String {
        String(likeCount)
    }
    public var elapsedTime: String {

        if UTCTime.day(diff: diff()) > 0 {
            return "\(UTCTime.day(diff: diff()))일 전"
        }
        else if UTCTime.hour(diff: diff()) > 0 {
            return "\(UTCTime.hour(diff: diff()))시간 전"
        }
        else if UTCTime.minute(diff: diff()) > 0 {
            return "\(UTCTime.minute(diff: diff()))분 전"
        }
        else {
            return "방금 전"
        }
        
        func diff() -> Int {
            UTCTime.current - createdAt
        }
        
    }
}
