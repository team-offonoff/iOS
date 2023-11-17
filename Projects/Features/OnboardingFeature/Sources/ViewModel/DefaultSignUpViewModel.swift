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

//    public init(){
//        super.init()
//    }
    
    public let jobs: [Job] = Job.allCases
    
    public let selectedJob: CurrentValueSubject<Job?, Never> = CurrentValueSubject(.none)
    public let moveHome: PassthroughSubject<Void, Never> = PassthroughSubject()
    
//    private let signUpUseCase: any SignUpUseCase
    
    public func input(_ input: SignUpViewModelInputValue) {
        
        let nicknamePublisher = input.nicknamePublisher
            .filter{ nickname in
                Regex.validate(data: nickname, pattern: .nickname)
            }
        
        let birthdayPublisher = input.birthdayPublisher
            .filter{ birthday in
                birthday.count == 8
            }
        
        let jobPublisher = selectedJob
//            .filter{ job in
//                job != .none
//            }
        
        let combinePublisher = nicknamePublisher
            .combineLatest(
                birthdayPublisher,
                input.genderPublisher,
                selectedJob
            )
//            .flatMap{
//                signUpUseCase.execute()
//            }
    }
    
    public func selectJob(_ job: Job) {
        selectedJob.send(job)
    }
}
