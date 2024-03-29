//
//  SignUpViewModel.swift
//  OnboardingFeatureInterface
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Domain
import FeatureDependency

public protocol SignUpViewModelInput {
    var jobSubject: PassthroughSubject<Job, Never> { get }
    func input(_ input: SignUpViewModelInputValue)
}

public struct SignUpViewModelInputValue {
    
    public init(
        nicknameEditingEnd: AnyPublisher<String, Never>,
        birthdayEditingEnd: AnyPublisher<String, Never>,
        gender: AnyPublisher<Gender, Never>,
        moveNext: AnyPublisher<Void, Never>
    ) {
        self.nicknameEditingEnd = nicknameEditingEnd
        self.birthdayEditingEnd = birthdayEditingEnd
        self.gender = gender
        self.moveNext = moveNext
    }
    
    public let nicknameEditingEnd: AnyPublisher<String, Never>
    public let birthdayEditingEnd: AnyPublisher<String, Never>
    public let gender: AnyPublisher<Gender, Never>
    public let moveNext: AnyPublisher<Void, Never>
}

public protocol SignUpViewModelOutput {
    var birthdayLimitCount: Int { get }
    ///닉네임의 유효성과 닉네임이 유효하지 않은 경우의 에러 메시지를 방출
    var nicknameValidation: PassthroughSubject<(Bool, String?), Never> { get }
    var birthdayValidation: PassthroughSubject<(Bool, String?), Never> { get }
    var canMove: CurrentValueSubject<Bool, Never> { get }
    var moveNext: (() -> Void)? { get set }
//    var failSignUp: PassthroughSubject<Void, Never> { get }
}

public typealias SignUpViewModel = BaseViewModel & SignUpViewModelInput & SignUpViewModelOutput
