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
        
        public init(text: String?, imageURL: URL?, type: String = "IMAGE_TEXT") {
            self.text = text
            self.imageURL = imageURL
            self.type = type
        }
        
        public let text: String?
        public let imageURL: URL?
        public let type: String
    }
    
    public init(
        id: Int,
        content: Choice.Content,
        option: Choice.Option,
        voteCount: Int?
    ) {
        self.id = id
        self.content = content
        self.option = option
        self.voteCount = voteCount
    }
    
    public let id: Int
    public let content: Content
    public let option: Choice.Option
    public let voteCount: Int?
}
