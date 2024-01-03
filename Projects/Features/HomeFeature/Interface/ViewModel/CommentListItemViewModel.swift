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
        self.createdAt = String(describing: comment.createdAt) //TODO: 데이터 가공
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
    public let createdAt: String
    ///option이 nil인 경우, 토픽 작성자를 의미한다
    public let selectedOption: (option: Choice.Option?, content: String)
    public let content: String
    public var isLike: Bool
    public var isHate: Bool
    public var likeCount: Int
    public var likeCountString: String {
        String(likeCount)
    }
}
