//
//  TestData.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/11/05.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public struct TestData {
    
    public static let topicA = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        categoryId: 0,
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: nil), option: .B)
        ],
        deadline: Int(Date.now.timeIntervalSince1970) + 10
    )
    
    public static let topicB = Topic(
        id: 1,
        side: .B,
        title: "10년 전 또는 후로 갈 수 있다면?",
        categoryId: 0,
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: nil), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: nil), option: .B)
        ],
        deadline: Int(Date.now.timeIntervalSince1970) + 60*60 + 5
    )
    
    public static let topicImage = Topic(
        id: 0,
        side: .A,
        title: "10년 전 또는 후로 갈 수 있다면?",
        categoryId: 0,
        choices: [
            Choice(id: 0, content: Choice.Content(text: "10년 전 과거로 가기", imageURL: URL(string: "http://ab")), option: .A),
            Choice(id: 1, content: Choice.Content(text: "10년 후 미래로 가기", imageURL: URL(string: "http://ab")), option: .B)
        ],
        deadline: Int(Date.now.timeIntervalSince1970) + 10
    )
}
