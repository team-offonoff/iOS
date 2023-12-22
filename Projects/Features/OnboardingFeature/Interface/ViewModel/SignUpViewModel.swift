//
//  SignUpViewModel.swift
//  OnboardingFeatureInterface
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Core

public protocol SignUpViewModelInput {
    func input(_ input: SignUpViewModelInputValue)
}

public struct SignUpViewModelInputValue {
    
    public init(
        nicknameEditingEnd: AnyPublisher<String, Never>
    ) {
        self.nicknameEditingEnd = nicknameEditingEnd
    }
    
    public let nicknameEditingEnd: AnyPublisher<String, Never>
//    public let birthdayText: AnyPublisher<String, Never>
//    public let gender: AnyPublisher<Gender, Never>
}

public protocol SignUpViewModelOutput {
    var nicknameLimitCount: Int { get }
    ///닉네임의 유효성과 닉네임이 유효하지 않은 경우의 에러 메시지를 방출
    var nicknameValidation: PassthroughSubject<(Bool, String?), Never> { get }
//    var isBirthdayValid: PassthroughSubject<(Bool, String), Never> { get }
//    var canMove: PassthroughSubject<Bool, Never> { get }
//    var moveHome: (() -> Void) { get set }
//    var failSignUp: PassthroughSubject<Void, Never> { get }
}

//public protocol JobSelectable {
//    var jobs: [Job] { get }
//    var selectedJob: CurrentValueSubject<Job?, Never> { get }
//    func selectJob(_ job: Job)
//}

public typealias SignUpViewModel = SignUpViewModelInput & SignUpViewModelOutput
