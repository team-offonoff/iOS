//
//  Choice.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core

public struct Choice {
    
    public struct Content {
        
        public init(text: String, imageURL: URL?) {
            self.text = text
            self.imageURL = imageURL
        }
        
        public let text: String
        public let imageURL: URL?
    }
    
    public init(
        id: Int,
        content: Choice.Content,
        option: ChoiceOption
    ) {
        self.id = id
        self.content = content
        self.option = option
    }
    
    public let id: Int
    public let content: Content
    public let option: ChoiceOption
}
