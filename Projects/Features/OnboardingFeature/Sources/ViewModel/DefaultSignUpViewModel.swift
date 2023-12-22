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
    
    public let nicknameLimitCount: Int = 8
    
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
//
//        let combinePublisher = nicknamePublisher
//            .combineLatest(
//                birthdayPublisher,
//                input.gender
//            )
//            .flatMap{
//                signUpUseCase.execute()
//            }
    }
}
