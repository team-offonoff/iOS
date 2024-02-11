//
//  TopicItemViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain

public struct TopicItemViewModel {
    
    public init(_ topic: Topic){
        self.topic = topic
    }
    
    public let topic: Topic
    
    public var commentPreview: Comment?
    public var id: Int {
        topic.id!
    }
}
