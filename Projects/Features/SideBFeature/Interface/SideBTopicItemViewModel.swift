//
//  SideBTopicItemViewModel.swift
//  SideBFeatureInterface
//
//  Created by 박소윤 on 2024/02/13.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import TopicFeatureInterface
import Domain
import Core

public struct SideBTopicItemViewModel {
    
    public init(_ topic: Topic){
        self.topic = topic
    }
    
    private let topic: Topic

    public var keyword: String {
        topic.keyword?.name ?? ""
    }
    public var elapsedTime: String {
        UTCTime.elapsedTime(createdAt: topic.createdAt)
    }
    public var isVoted: Bool {
        topic.selectedOption != nil
    }
    public var title: String {
        topic.title
    }
    public var id: Int {
        topic.id
    }
    public var voteCount: String {
        "\(ABFormat.count(topic.voteCount)) 명"
    }
    public var commentCount: String {
        "\(topic.commentCount)"
    }
    public func content(of option: Choice.Option) -> (Topic.ContentType, Any) {
        if let text = topic.choices[option]?.content.text {
            return (.text, text)
        }
        else if let image = topic.choices[option]?.content.imageURL {
            return (.image, image)
        }
        else {
            fatalError()
        }
    }
    
}
