//
//  DefaultSignUpViewModel.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import OnboardingFeatureInterface
import FeatureDependency
import Domain
import Core

public final class DefaultSignUpViewModel: BaseViewModel, SignUpViewModel {
    
    public init(
        signUpUseCase: any SignUpUseCase
    ){
        self.signUpUseCase = signUpUseCase
    }
    
    private let signUpUseCase: any SignUpUseCase
    private var signUpRequestValue: SignUpUseCaseRequestValue?
    
    //MARK: Output
    
    public let canMove: PassthroughSubject<Bool, Never> = PassthroughSubject()
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    public let nicknameValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    public let birthdayValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    
    public let jobs: [Job] = Job.allCases
    public let nicknameLimitCount: Int = 8
    public let birthdayLimitCount: Int = 8
    
    public var moveHome: (() -> Void)?
}

//MARK: Input

extension DefaultSignUpViewModel {
    
    public func input(_ input: SignUpViewModelInputValue) {
        
        input.nicknameEditingEnd
            .sink{ [weak self] nickname in
                
                guard let self = self else { return }
                
                self.nicknameValidation.send(validation())
                
                func validation() -> (Bool, String?) {
                    if nickname.count > self.nicknameLimitCount || nickname.count == 0 {
                        return (false, "* 글자 수 초과")
                    }
                    else if !Regex.validate(data: nickname, pattern: .nickname) {
                        return (false, "* 한글, 영문, 숫자만 가능해요.")
                    }
                    else {
                        return (true, nil)
                    }
                }
            }
            .store(in: &cancellable)
        
        
        input.birthdayEditingEnd
            .sink{ [weak self] birthday in
                
                guard let self = self else { return }
                
                self.birthdayValidation.send(validation())
                
                func validation() -> (Bool, String?) {
                    if birthday.count != self.birthdayLimitCount {
                        return (false, "* 생년월일을 8자로 입력해주세요.")
                    }
                    return (true, nil)
                }
                
            }
            .store(in: &cancellable)
        
        nicknameValidation
            .combineLatest(birthdayValidation, input.gender)
            .sink{ [weak self] nickname, birthday, _ in
                
                guard let self = self else { return }
                
                self.canMove.send(canMove())
                
                func canMove() -> Bool {
                    nickname.0 && birthday.0
                }
            }
            .store(in: &cancellable)
        
        //signUpRequestValue 갱신을 위해 combine lastest로 데이터를 모으고, 조건을 검사한다.
        canMove.combineLatest(input.nicknameEditingEnd, input.birthdayEditingEnd, input.gender)
            .sink{ [weak self] canMove, nickname, birth, gender in
                if canMove {
                    self?.signUpRequestValue = SignUpUseCaseRequestValue(memberId: 0, nickname: nickname, birth: birth, gender: gender, job: "")
                }
                else {
                    self?.signUpRequestValue = nil
                }
            }
            .store(in: &cancellable)
        
        input.moveNext
            .compactMap{ [weak self] _ in
                self?.signUpRequestValue
            }
            .flatMap{ request in
                self.signUpUseCase.execute(request: request)
            }
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.moveHome?()
                }
                else {
                    if let error = result.error {
                        self.errorHandler.send(error)
                    }
                }
                
            }
            .store(in: &cancellable)
    }
}
