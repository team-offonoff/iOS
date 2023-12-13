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
    
    public init() {
        self.profileImageUrl = URL(string: "http://ab.")!
        self.nickname = "닉네임닉네임"
        self.date = "2일전" //comment.date
        self.choice = "A. 일이삼사오육칠팔구십일이삼사오육칠팔구십" //comment.choice
        self.content = "왜들 그리 다운돼있어? 뭐가 문제야 say something 분위기가 겁나 싸해 요새는 이런 게 유행인가 왜들 그리 재미없어? 아 그건 나도 마찬가지"
        self.likeCount = String(129)
    }

    public init(
        comment: Comment
    ) {
        self.profileImageUrl = comment.writer.profileImageURl
        self.nickname = comment.writer.nickname
        self.date = "" //comment.date
        self.choice = "" //comment.choice
        self.content = comment.content
        self.likeCount = String(comment.likes)
    }
    
    public let profileImageUrl: URL
    public let nickname: String
    public let date: String
    public let choice: String
    public let content: String
    public let likeCount: String
}
