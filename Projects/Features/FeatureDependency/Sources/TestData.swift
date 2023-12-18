//
//  TestData.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/11/05.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

public struct TestData {
    
    public static let topicData1 = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        deadline: UTCTime.current + 10,
        voteCount: 100,
        keyword: .init(id: 0, name: "키워드", topicSide: .A),
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: nil), option: .B)
        ],
        author: .init(id: 0, nickname: "닉네임", profileImageUrl: nil),
        selectedOption: nil
    )
    
    public static let topicData2 = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        deadline: UTCTime.current + 24*60,
        voteCount: 100,
        keyword: .init(id: 0, name: "키워드", topicSide: .A),
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: nil), option: .B)
        ],
        author: .init(id: 0, nickname: "닉네임", profileImageUrl: nil),
        selectedOption: .A
    )
    
    public static let topicData3 = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        deadline: UTCTime.current + 24*60,
        voteCount: 100,
        keyword: .init(id: 0, name: "키워드", topicSide: .A),
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: nil), option: .B)
        ],
        author: .init(id: 0, nickname: "닉네임", profileImageUrl: nil),
        selectedOption: .B
    )
    
    public static let topicData4 = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        deadline: UTCTime.current + 24*60,
        voteCount: 100,
        keyword: .init(id: 0, name: "키워드", topicSide: .A),
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: URL(string: "http://ab")), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: URL(string: "http://ab")), option: .B)
        ],
        author: .init(id: 0, nickname: "닉네임", profileImageUrl: nil),
        selectedOption: .B
    )
}
