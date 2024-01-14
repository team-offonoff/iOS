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
        signUpUseCase: any GenerateProfileUseCase
    ){
        self.signUpUseCase = signUpUseCase
    }
    
    private let signUpUseCase: any GenerateProfileUseCase
    private var signUpRequestValue: GenerateProfileUseCaseRequestValue?
    
    //MARK: Output
    
    public let jobSubject: PassthroughSubject<Job, Never> = PassthroughSubject()
    public let canMove: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    public let nicknameValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    public let birthdayValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    
    public let jobs: [Job] = Job.allCases
    public let nicknameLimitCount: Int = 8
    public let birthdayLimitCount: Int = 8
    
    public var moveNext: (() -> Void)?
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
                    else if wrongFormat() {
                        return (false, "* 잘못된 날짜 형식입니다.")
                    }
                    return (true, nil)
                        
                    func wrongFormat() -> Bool {
                        let formatter = DateFormatter()
                        //입력값 기준 포맷
                        formatter.dateFormat = "yyyyMMdd"
                        return  formatter.date(from: birthday) == nil
                    }
                }
                
            }
            .store(in: &cancellable)
        
        nicknameValidation
            .combineLatest(birthdayValidation, input.gender, jobSubject)
            .sink{ [weak self] nickname, birthday, gender, job in
                
                guard let self = self else { return }
                
                self.canMove.send(canMove())
                
                func canMove() -> Bool {
                    nickname.0 && birthday.0
                }
            }
            .store(in: &cancellable)
        
        //signUpRequestValue 갱신을 위해 combine lastest로 데이터를 모으고, 조건을 검사한다.
        jobSubject.combineLatest(input.nicknameEditingEnd, input.birthdayEditingEnd, input.gender)
            .sink{ [weak self] job, nickname, birth, gender in
                guard let self = self else { return }
                if self.canMove.value {
                    guard let memberId = UserManager.shared.memberId else { return }
                    self.signUpRequestValue = GenerateProfileUseCaseRequestValue(
                        memberId: memberId,
                        nickname: nickname,
                        birth: birthFormat(),
                        gender: gender,
                        job: job
                    )
                }
                else {
                    self.signUpRequestValue = nil
                }
                
                func birthFormat() -> String {
                    let formatter = DateFormatter()
                    //입력값 기준 포맷
                    formatter.dateFormat = "yyyyMMdd"
                    let date = formatter.date(from: birth)!

                    //서버 전송용 포맷
                    formatter.dateFormat = "yyyy-MM-dd"
                    return formatter.string(from: date)
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
                    self.moveNext?()
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
