//
//  CommentListItemViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public struct CommentListItemViewModel {
    
//    public init() {
//        self.id = 0
//        self.profileImageUrl = URL(string: "http://ab.")!
//        self.nickname = "닉네임닉네임"
//        self.createdAt = "2일전" //comment.date
//        self.choice = "A. 일이삼사오육칠팔구십일이삼사오육칠팔구십" //comment.choice
//        self.content = "왜들 그리 다운돼있어? 뭐가 문제야 say something 분위기가 겁나 싸해 요새는 이런 게 유행인가 왜들 그리 재미없어? 아 그건 나도 마찬가지"
//        self.likeCount = 129
//        self.isLike = false
//        self.isHate = false
//    }

    public init(
        _ comment: Comment
    ) {
        self.id = comment.commentId
        self.profileImageUrl = comment.writer.profileImageURl
        self.nickname = comment.writer.nickname
        self.createdAt = comment.createdAt //TODO: 데이터 가공
        self.choice = "" //comment.choice //TODO: 데이터 가공
        self.content = comment.content
        self.isLike = comment.isLike
        self.isHate = comment.isHate
        self.likeCount = comment.likeCount
    }
    
    public let id: Int
    public let profileImageUrl: URL?
    public let nickname: String
    public let createdAt: String
    public let choice: String
    public let content: String
    public var isLike: Bool
    public var isHate: Bool
    public var likeCount: Int
    public var likeCountString: String {
        String(likeCount)
    }
}
