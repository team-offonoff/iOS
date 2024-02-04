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

public typealias TopicGenerateViewModel = TopicGenerateViewModelInput & TopicGenerateViewModelOutput & TopicGenerateASideViewModel & TopicGenerateBSideViewModel & ErrorHandleable

public typealias TopicGenerateASideViewModel = TopicGenerateASideViewModelInput & TopicGenerateASideViewModelOutput

public typealias TopicGenerateBSideViewModel = TopicGenerateBSideViewModelInput & TopicGenerateBSideViewModelOutput

public typealias Validation = (Bool, String?)

public protocol TopicGenerateViewModelInput {
    var topicSide: CurrentValueSubject<Topic.Side, Never> { get }
    var contentType: CurrentValueSubject<Topic.ContentType, Never> { get }
    func register(_ request: GenerateTopicUseCaseRequestValue)
}

public protocol TopicGenerateASideViewModelInput {
    var deadlinePublisher: CurrentValueSubject<Int, Never> { get }
    func sideAInput(content: TopicGenerateContentViewModelInputValue, choices: TopicGenerateChoiceContentViewModelInputValueTest)
}

public protocol TopicGenerateASideViewModelOutput {
    var sideATitleValidation: CurrentValueSubject<Validation, Never> { get }
    var sideACanSwitchOption: CurrentValueSubject<Bool, Never> { get }
    var sideAOptionAValidation: CurrentValueSubject<Validation, Never> { get }
    var sideAOptionBValidation: CurrentValueSubject<Validation, Never> { get }
    var canSideARegister: CurrentValueSubject<Bool, Never> { get }
}

public protocol TopicGenerateBSideViewModelInput {
    var deadlinePublisher: CurrentValueSubject<Int, Never> { get }
    var tempStorage: (title: String, keyword: String)? { get set }
    func sideBInput(content: TopicGenerateContentViewModelInputValue)
    func sideBChoiceInput(content: TopicGenerateChoiceContentViewModelInputValueTest)
}

public protocol TopicGenerateBSideViewModelOutput {
    var sideBTitleValidation: CurrentValueSubject<Validation, Never> { get }
    var sideBKeywordValidation: CurrentValueSubject<Validation, Never> { get }
    var sideBCanSwitchOption: CurrentValueSubject<Bool, Never> { get }
    var moveNextInput: PassthroughSubject<Void, Never> { get }
    var cansideBRegister: CurrentValueSubject<Bool, Never> { get }
    func generateChoice(option: Choice.Option, content: Any) -> GenerateChoiceOptionUseCaseRequestValue
}

public protocol TopicGenerateViewModelOutput {
    var topicSide: CurrentValueSubject<Topic.Side, Never> { get }
    var recommendKeywords: [String] { get }
    var limitCount: TopicGenerateTextLimitCount { get }
    func otherTopicSide() -> Topic.Side
    var successRegister: (() -> Void)? { get set }
}

public struct TopicGenerateTextLimitCount {
    
    public init() { }
    
    public let title: Int = 20
    public let keyword: Int = 6
    public let textOption: Int = 25
    public let imageComment: Int = 12
}

public struct TopicGenerateContentViewModelInputValue {
    
    public init(
        titleDidEnd: AnyPublisher<String, Never>,
        keywordDidEnd: AnyPublisher<String, Never>?
    ) {
        self.titleDidEnd = titleDidEnd
        self.keywordDidEnd = keywordDidEnd
    }
    
    public let titleDidEnd: AnyPublisher<String, Never>
    public let keywordDidEnd: AnyPublisher<String, Never>?
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
}

public struct TopicGenerateChoiceContentViewModelInputValueTest {
    
    public init(
        choiceA: AnyPublisher<Any?, Never>,
        choiceB: AnyPublisher<Any?, Never>
    ) {
        self.choiceA = choiceA
        self.choiceB = choiceB
    }
    
    public let choiceA: AnyPublisher<Any?, Never>
    public let choiceB: AnyPublisher<Any?, Never>
}
