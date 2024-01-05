//
//  TopicGenerateRequestDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

struct TopicGenerateRequestDTO: Encodable {
    
    let side: String
    let keywordName: String
    let title: String
    let choices: [ChoiceRequestDTO]
    let deadline: Int
    
    struct ChoiceRequestDTO: Encodable {
        
        let choiceOption: String
        let choiceContentRequest: ContentRequestDTO
        
        struct ContentRequestDTO: Encodable {
            let type: String
            let imageUrl: String?
            let text: String
        }
    }
}
