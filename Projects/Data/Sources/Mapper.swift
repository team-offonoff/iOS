//
//  Mapper.swift
//  Data
//
//  Created by 박소윤 on 2023/12/18.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct Mapper{
    
    //MARK: Topic Side
    
    private static let topicSideMap: [Topic.Side: String] = [.A: "TOPIC_A", .B: "TOPIC_B"]
    
    static func entity(topicSide: String) -> Topic.Side {
        topicSideMap.filter{ $0.value == topicSide }.first!.key
    }
    
    static func dto(topicSide: Topic.Side) -> String {
        topicSideMap[topicSide]!
    }
    
    //MARK: Choice Option
    
    private static let choiceOptionMap: [Choice.Option: String] = [.A: "CHOICE_A", .B: "CHOICE_B"]
    
    static func entity(choiceOption: String?) -> Choice.Option? {
        choiceOptionMap.filter{ $0.value == choiceOption }.first?.key
    }
    
    static func dto(choiceOption: Choice.Option) -> String {
        choiceOptionMap[choiceOption]!
    }
}
