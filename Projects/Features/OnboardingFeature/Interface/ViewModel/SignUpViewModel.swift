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
        birthdayPublisher: AnyPublisher<String, Never>,
        genderPublisher: AnyPublisher<Gender, Never>
    ) {
        self.nicknamePublisher = nicknamePublisher
        self.birthdayPublisher = birthdayPublisher
        self.genderPublisher = genderPublisher
    }

    public let nicknamePublisher: AnyPublisher<String, Never>
    public let birthdayPublisher: AnyPublisher<String, Never>
    public let genderPublisher: AnyPublisher<Gender, Never>
}

public protocol SignUpViewModelOutput {
    var moveHome: PassthroughSubject<Void, Never> { get }
}

public protocol JobSelectable {
    var jobs: [Job] { get }
    var selectedJob: CurrentValueSubject<Job?, Never> { get }
    func selectJob(_: Job)
}

public protocol SignUpViewModel:
    SignUpViewModelInput,
    SignUpViewModelOutput,
    JobSelectable {
}
