//
//  MockChoice.swift
//  CommentFeatureTests
//
//  Created by 박소윤 on 2024/01/09.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

let mockTextChoices: [Choice] = [
    .init(id: 0, content: .init(text: "CHOICE_A", imageURL: nil), option: .A),
    .init(id: 1, content: .init(text: "CHOICE_B", imageURL: nil), option: .B)
]

let mockImageChoices: [Choice] = [
    .init(id: 0, content: .init(text: "CHOICE_A", imageURL: URL(string:"http://ab/choiceA")), option: .A),
    .init(id: 1, content: .init(text: "CHOICE_B", imageURL: URL(string:"http://ab/choiceB")), option: .B)
]
