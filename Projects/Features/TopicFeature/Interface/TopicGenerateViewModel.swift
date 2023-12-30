//
//  TopicGenerateViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2023/12/30.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain
import Combine

public typealias TopicGenerateViewModel = TopicGenerateViewModelInput & TopicGenerateViewModelOutput & ErrorHandleable

public protocol TopicGenerateViewModelInput {
    var topicSide: PassthroughSubject<Topic.Side, Never> { get }
    func input(content: TopicGenerateContentViewModelInputValue)
//    func input(choiceContent: TopicGenerateChoiceContentViewModelInputValue)
}

public protocol TopicGenerateViewModelOutput {
    var topicSide: PassthroughSubject<Topic.Side, Never> { get }
    var recommendKeywords: [String] { get }
    var titleLimitCount: Int { get }
    var keywordLimitCount: Int { get }
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

//public struct TopicGenerateChoiceContentViewModelInputValue {
//    public let canRegister: AnyPublisher<Bool, Never>
//    public let register: AnyPublisher<Void, Never>
//}
