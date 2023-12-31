//
//  TopicGenerateViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2023/12/30.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import FeatureDependency
import Domain
import Combine

public typealias TopicGenerateViewModel = TopicGenerateViewModelInput & TopicGenerateViewModelOutput & ErrorHandleable

public protocol TopicGenerateViewModelInput {
    var topicSide: CurrentValueSubject<Topic.Side, Never> { get }
    var contentType: CurrentValueSubject<Topic.ContentType, Never> { get }
    func input(content: TopicGenerateContentViewModelInputValue)
    func input(choiceContent: TopicGenerateChoiceContentViewModelInputValue)
    func register(_ request: GenerateTopicUseCaseRequestValue)
}

public protocol TopicGenerateViewModelOutput {
    var topicSide: CurrentValueSubject<Topic.Side, Never> { get }
    var recommendKeywords: [String] { get }
    var limitCount: TopicGenerateTextLimitCount { get }
    var contentValidation: CurrentValueSubject<Bool, Never> { get }
    var canRegister: PassthroughSubject<Bool, Never> { get }
}

public struct TopicGenerateTextLimitCount {
    
    public init() { }
    
    public let title: Int = 12
    public let keyword: Int = 6
    public let textOption: Int = 12
    public let imageComment: Int = 12
}

public struct TopicGenerateContentViewModelInputValue {
    
    public init(
        titleDidEnd: AnyPublisher<String, Never>,
        keywordDidEnd: AnyPublisher<String, Never>
    ) {
        self.titleDidEnd = titleDidEnd
        self.keywordDidEnd = keywordDidEnd
    }
    
    public let titleDidEnd: AnyPublisher<String, Never>
    public let keywordDidEnd: AnyPublisher<String, Never>
}

public struct TopicGenerateChoiceContentViewModelInputValue {
    
    public init(
        choiceAText: AnyPublisher<String, Never>,
        choiceBText: AnyPublisher<String, Never>,
        choiceAImage: AnyPublisher<UIImage?, Never>?,
        choiceBImage: AnyPublisher<UIImage?, Never>?
    ) {
        self.choiceAText = choiceAText
        self.choiceBText = choiceBText
        self.choiceAImage = choiceAImage
        self.choiceBImage = choiceBImage
    }
    
    public let choiceAText: AnyPublisher<String, Never>
    public let choiceBText: AnyPublisher<String, Never>
    public let choiceAImage: AnyPublisher<UIImage?, Never>?
    public let choiceBImage: AnyPublisher<UIImage?, Never>?
//    public let deadline: AnyPublisher<Int, Void>
}
