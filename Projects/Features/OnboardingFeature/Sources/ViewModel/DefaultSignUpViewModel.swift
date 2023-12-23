//
//  DefaultSignUpViewModel.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import FeatureDependency
import OnboardingFeatureInterface
import Core

public final class DefaultSignUpViewModel: BaseViewModel, SignUpViewModel {
   
    public let jobs: [Job] = Job.allCases
    public let nicknameValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    public let birthdayValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    public let canMove: PassthroughSubject<Bool, Never> = PassthroughSubject()
    
    public let nicknameLimitCount: Int = 8
    public let birthdayLimitCount: Int = 8
    
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

        //TODO: 직업 추가하기
        nicknameValidation
            .combineLatest(
                birthdayValidation,
                input.gender
            )
            .sink{ [weak self] nickname, birthday, _ in
                
                guard let self = self else { return }
                
                self.canMove.send(canMove())
                
                func canMove() -> Bool {
                    nickname.0 && birthday.0
                }
            }
            .store(in: &cancellable)
    }
}
