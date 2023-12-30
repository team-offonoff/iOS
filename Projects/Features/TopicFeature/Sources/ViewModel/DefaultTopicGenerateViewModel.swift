//
//  DefaultTopicGenerateViewModel.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/30.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import TopicFeatureInterface
import FeatureDependency
import Combine
import Domain

final class DefaultTopicGenerateViewModel: BaseViewModel, TopicGenerateViewModel {
    
    init(topicGenerateUseCase: any GenerateTopicUseCase) {
        self.topicGenerateUseCase = topicGenerateUseCase
        super.init()
    }
    
    private let topicGenerateUseCase: any GenerateTopicUseCase
    
    //MARK: Input & Output
    
    let topicSide: PassthroughSubject<Topic.Side, Never> = PassthroughSubject()
    let contentType: CurrentValueSubject<Topic.ContentType, Never> = CurrentValueSubject(.text)
    
    //MARK: Output
    
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()

    let recommendKeywords: [String] = ["스포츠", "연예방송", "일상다반사", "게임", "일상다반사"]
    let titleLimitCount: Int = 12
    let keywordLimitCount: Int = 6
    
    //MARK: Input
    
    func input(content: TopicGenerateContentViewModelInputValue) {
        
    }
    
}
