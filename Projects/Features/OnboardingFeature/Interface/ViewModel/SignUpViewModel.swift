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
        nicknamePublisher: AnyPublisher<String, Never>,
        birthdayPublisher: AnyPublisher<String, Never>
    ) {
        self.nicknamePublisher = nicknamePublisher
        self.birthdayPublisher = birthdayPublisher
    }
    
    public let nicknamePublisher: AnyPublisher<String, Never>
    public let birthdayPublisher: AnyPublisher<String, Never>
}

public protocol SignUpViewModelOutput {
    var moveHome: PassthroughSubject<Void, Never> { get }
}

public protocol JobSelectable {
    var jobs: [Job] { get }
    var selectedJob: CurrentValueSubject<Job?, Never> { get }
    func selectJob(_: Job)
}

public protocol GenderSelectable {
    var selectedGender: CurrentValueSubject<Gender?, Never> { get }
    func selectGender(_: Gender)
}

public protocol SignUpViewModel:
    SignUpViewModelInput,
    SignUpViewModelOutput,
    JobSelectable,
    GenderSelectable {
}
