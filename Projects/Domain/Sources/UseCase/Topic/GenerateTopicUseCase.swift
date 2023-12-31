//
//  GenerateTopicUseCase.swift
//  Domain
//
//  Created by 박소윤 on 2023/11/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Core
import UIKit

public protocol GenerateTopicUseCase: UseCase {
    func execute(request: GenerateTopicUseCaseRequestValue) -> NetworkResultPublisher<Topic?>
}

public final class DefaultGenerateTopicUseCase: GenerateTopicUseCase {
    
    private let repository: TopicRepository
    
    public init(repository: TopicRepository) {
        self.repository = repository
    }
    
    public func execute(request: GenerateTopicUseCaseRequestValue) -> NetworkResultPublisher<Topic?> {
        repository.generateTopic(request: request)
    }
}

public struct GenerateTopicUseCaseRequestValue {
    
    public init(
        side: Topic.Side,
        keyword: String,
        title: String,
        choices: [GenerateChoiceOptionUseCaseRequestValue],
        deadline: Int
    ) {
        self.side = side
        self.keyword = keyword
        self.title = title
        self.choices = choices
        self.deadline = deadline
    }

    public let side: Topic.Side
    public let keyword: String
    public let title: String
    public let choices: [GenerateChoiceOptionUseCaseRequestValue]
    public let deadline: Int
}

public struct GenerateChoiceOptionUseCaseRequestValue {
    
    public init(text: String, image: UIImage?, option: Choice.Option) {
        self.text = text
        self.image = image
        self.option = option
    }
    
    public let text: String
    public let image: UIImage?
    public let option: Choice.Option
    public let type: String = "IMAGE_TEXT"
    
}
