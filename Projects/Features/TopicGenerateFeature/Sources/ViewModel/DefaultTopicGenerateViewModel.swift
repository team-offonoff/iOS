//
//  DefaultTopicGenerateViewModel.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/30.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import TopicGenerateFeatureInterface
import FeatureDependency
import Combine
import Domain
import UIKit
import Core

fileprivate struct ChoiceContentPublisherStorage {
    
    var contents: AnyCancellable?
    
    func cancel(){
        [contents].forEach{
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
        publisherStorage.cancel()
    }
    
    private let topicGenerateUseCase: any GenerateTopicUseCase
    private var publisherStorage: ChoiceContentPublisherStorage = ChoiceContentPublisherStorage()
    @Published private var choiceContentValidation: Bool = false
    
    //MARK: Input & Output
    
    let topicSide: CurrentValueSubject<Topic.Side, Never> = CurrentValueSubject(.A)
    let contentType: CurrentValueSubject<Topic.ContentType, Never> = CurrentValueSubject(.text)
    
    //MARK: Output
    
    var successRegister: (() -> Void)?
    
    //Side A
    let sideATitleValidation: CurrentValueSubject<Validation, Never> = CurrentValueSubject((false, nil))
    let sideAOptionAValidation: CurrentValueSubject<Validation, Never> = CurrentValueSubject((false, nil))
    let sideAOptionBValidation: CurrentValueSubject<Validation, Never> = CurrentValueSubject((false, nil))
    let sideACanSwitchOption: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let canSideARegister: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    //side b
    var tempStorage: (title: String, keyword: String)?
    let deadlinePublisher: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    let sideBTitleValidation: CurrentValueSubject<Validation, Never> = CurrentValueSubject((false, nil))
    let sideBKeywordValidation: CurrentValueSubject<Validation, Never> = CurrentValueSubject((false, nil))
    let sideBCanSwitchOption: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let moveNextInput: PassthroughSubject<Void, Never> = PassthroughSubject()
    let cansideBRegister: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    let canRegister: PassthroughSubject<Bool, Never> = PassthroughSubject()
    let contentValidation: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    let recommendKeywords: [String] = ["스포츠", "연예방송", "일상다반사", "게임", "일상다반사"]
    
    func otherTopicSide() -> Topic.Side {
        Topic.Side.allCases.filter{ $0 != topicSide.value }.first!
    }
    
    //MARK: Input
    
    private func validation(title: String) -> (Bool, String?) {
        print(title, Regex.validate(data: title, pattern: .topicTitle))
        if Regex.validate(data: title, pattern: .topicTitle) {
            return (true, nil)
        }
        return (false, "* 특수문자는 !@#$%^()만 사용하실 수 있습니다.")
    }
    
    private func validation(option: String) -> (Bool, String?) {
        if Regex.validate(data: option, pattern: .choiceContent) {
            return (true, nil)
        }
        return (false, "* 특수문자는 !@#$%^()만 사용하실 수 있습니다.")
    }
    
    func sideAInput(content: TopicGenerateContentViewModelInputValue, choices: TopicGenerateChoiceContentViewModelInputValueTest) {
        
        content.titleDidEnd
            .sink{ [weak self] in
                guard let self = self else { return }
                self.sideATitleValidation.send(self.validation(title: $0))
            }
            .store(in: &cancellable)
        
        choices.choiceA
            .sink{ [weak self] option in
                guard let self = self, let option = option as? String else { return }
                self.sideAOptionAValidation.send(self.validation(option: option))
            }
            .store(in: &cancellable)
        
        choices.choiceB
            .sink{ [weak self] option in
                guard let self = self, let option = option as? String else { return }
                self.sideAOptionBValidation.send(self.validation(option: option))
            }
            .store(in: &cancellable)
        
        
        sideATitleValidation
            .combineLatest(sideAOptionAValidation, sideAOptionBValidation)
            .sink{ [weak self] title, optionA, optionB in
                guard let self = self else { return }
                self.sideACanSwitchOption.send(self.sideAOptionAValidation.value.0 || self.sideAOptionBValidation.value.0)
                self.canSideARegister.send(title.0 && optionA.0 && optionB.0)
            }
            .store(in: &cancellable)
    }
    
    func sideBInput(content: TopicGenerateContentViewModelInputValue) {
        
        content.titleDidEnd
            .sink{ [weak self] title in
                guard let self = self else { return }
                self.sideBTitleValidation.send(self.validation(title: title))
            }
            .store(in: &cancellable)
        
        content.keywordDidEnd?
            .sink{ [weak self] keyword in
                guard let self = self else { return }
                self.sideBKeywordValidation.send(keywordValidation())
                
                func keywordValidation() -> (Bool, String?) {
                    if Regex.validate(data: keyword, pattern: .topicKeyword) {
                        return (true, nil)
                    }
                    return (false, "* 한글, 영문, 숫자만 사용하실 수 있습니다.")
                }
                
            }
            .store(in: &cancellable)
        
        sideBTitleValidation.combineLatest(sideBKeywordValidation)
            .sink{ [weak self] title, keyword in
                guard let self = self else { return }
                if title.0 && keyword.0 {
                    self.moveNextInput.send(())
                }
            }
            .store(in: &cancellable)
        
    }
    
    func sideBChoiceInput(content: TopicGenerateChoiceContentViewModelInputValueTest) {
        
        publisherStorage.cancel()
        
        if contentType.value == .text {
            publisherStorage.contents = content.choiceA.combineLatest(content.choiceB)
                .sink{ [weak self] contentA, contentB in
                    guard let self = self , let contentA = contentA as? String,  let contentB = contentB as? String else { return }
                    
                    self.sideBCanSwitchOption.send(self.validation(option: contentA).0 && self.validation(option: contentB).0)
                    self.cansideBRegister.send(self.validation(option: contentA).0 && self.validation(option: contentB).0)
                }
            
        }
        else if contentType.value == .image {
            publisherStorage.contents = content.choiceA.combineLatest(content.choiceB)
                .sink{ [weak self] contentA, contentB in
                    
                    guard let self = self else { return }
                    
                    let contentA = contentA as? UIImage
                    let contentB = contentB as? UIImage
                    
                    self.sideBCanSwitchOption.send(validation(of: contentA) || validation(of: contentB))
                    self.cansideBRegister.send(validation(of: contentA) && validation(of: contentB))
                    
                    func validation(of image: UIImage?) -> Bool {
                        image != nil
                    }
                }
        }
    }
    

    func generateChoice(option: Choice.Option, content: Any) -> GenerateChoiceOptionUseCaseRequestValue {
        if contentType.value == .text {
            return .init(text: content as? String, image: nil, option: option)
        }
        else {
            return .init(text: nil, image: content as? UIImage, option: option)
        }
    }
    
    func register(_ request: GenerateTopicUseCaseRequestValue) {
        Task {
            await topicGenerateUseCase.execute(request: request)
                .sink{ [weak self] result in
                    if result.isSuccess {
                        print("success")
                        self?.successRegister?()
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
