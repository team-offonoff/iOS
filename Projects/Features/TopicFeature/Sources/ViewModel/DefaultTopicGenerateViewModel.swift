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
import UIKit

fileprivate struct ChoiceContentPublisherStorage {
    
    var textType: AnyCancellable?
    var imageType: AnyCancellable?
    
    func cancelAll(){
        [textType, imageType].forEach{
            $0?.cancel()
        }
    }
}

final class DefaultTopicGenerateViewModel: BaseViewModel, TopicGenerateViewModel {

    init(topicGenerateUseCase: any GenerateTopicUseCase) {
        self.topicGenerateUseCase = topicGenerateUseCase
        super.init()
    }
    
    deinit {
        choiceContentPublisherStorage?.cancelAll()
    }
    
    private let topicGenerateUseCase: any GenerateTopicUseCase
    private var choiceContentPublisherStorage: ChoiceContentPublisherStorage? = ChoiceContentPublisherStorage()
    @Published private var choiceContentValidation: Bool = false
    
    //MARK: Input & Output
    
    let topicSide: CurrentValueSubject<Topic.Side, Never> = CurrentValueSubject(.A)
    let contentType: CurrentValueSubject<Topic.ContentType, Never> = CurrentValueSubject(.text)
    
    //MARK: Output
    
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    let canRegister: PassthroughSubject<Bool, Never> = PassthroughSubject()
    let contentValidation: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    let recommendKeywords: [String] = ["스포츠", "연예방송", "일상다반사", "게임", "일상다반사"]
    let limitCount: TopicGenerateTextLimitCount = TopicGenerateTextLimitCount()
    
    func otherTopicSide() -> Topic.Side {
        Topic.Side.allCases.filter{ $0 != topicSide.value }.first!
    }
    
    //MARK: Input
    
    func input(content: TopicGenerateContentViewModelInputValue) {
        
        content.titleDidEnd
            .combineLatest(content.keywordDidEnd)
            .sink{ [weak self] title , keyword in
                
                guard let self = self else { return }
                
                self.contentValidation.send(isValid())
                
                func isValid() -> Bool {
                    
                    return titleValidation() && keywordValidation()
                    
                    func titleValidation() -> Bool {
                        title.count > 0 && title.count <= self.limitCount.title
                    }
                    
                    func keywordValidation() -> Bool {
                        keyword.count > 0 && keyword.count <= self.limitCount.keyword
                    }
                }
                
            }
            .store(in: &cancellable)
    }
    
    func input(choiceContent: TopicGenerateChoiceContentViewModelInputValue) {
        
        choiceContentPublisherStorage?.cancelAll()
        
        if contentType.value == .text {
            choiceContentPublisherStorage?.textType = choiceContent.choiceAText
                .combineLatest(choiceContent.choiceBText)
                .sink{ [weak self] aText, bText in
                    
                    guard let self = self else { return }

                    self.choiceContentValidation = isTextValid(aText) && isTextValid(bText)
                    
                    func isTextValid(_ text: String) -> Bool {
                        text.count > 0 && text.count <= self.limitCount.textOption
                    }
                }
        }
        else if contentType.value == .image {
            
            guard let choiceAImage = choiceContent.choiceAImage, let choiceBImage = choiceContent.choiceBImage else { return }
            
            choiceContentPublisherStorage?.imageType = choiceContent.choiceAText
                .combineLatest(choiceContent.choiceBText, choiceAImage, choiceBImage)
                .sink{ [weak self] aText, bText, aImage, bImage in
                    
                    guard let self = self else { return }
                    
                    self.choiceContentValidation = isTextValid(aText) && isTextValid(bText) && isImageValid()
                    
                    func isTextValid(_ text: String) -> Bool {
                        text.count > 0 && text.count <= self.limitCount.imageComment
                    }
                    
                    func isImageValid() -> Bool {
                        aImage != nil && bImage != nil
                    }
                }
        }
        
    }
    
    func register(_ request: GenerateTopicUseCaseRequestValue) {
        Task {
            await topicGenerateUseCase.execute(request: request)
                .sink{ [weak self] result in
                    if result.isSuccess {
                        print("success")
                    }
                    else {
                        if let error = result.error {
                            self?.errorHandler.send(error)
                        }
                    }
                }
                .store(in: &cancellable)
        }
    }
    
    
    override func bind() {
        contentValidation.combineLatest($choiceContentValidation)
            .map{
                $0 && $1
            }
            .sink{ [weak self] in
                self?.canRegister.send($0)
            }
            .store(in: &cancellable)
    }
    
}
