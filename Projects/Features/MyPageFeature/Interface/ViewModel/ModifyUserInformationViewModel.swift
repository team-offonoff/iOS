//
//  ModifyUserInformationViewModel.swift
//  MyPageFeatureInterface
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import UIKit
import FeatureDependency
import Domain

public struct Verification {
    
    public init(data: Any, isValid: Bool, errorMessage: String? ) {
        self.data = data
        self.isValid = isValid
        self.errorMessage = errorMessage
    }
    
    public let data: Any
    public let isValid: Bool
    public let errorMessage: String?
}

public typealias ModifyUserInformationViewModel = ModifyUserInformationViewModelInput & ModifyUserInformationViewModelOutput & ErrorHandleable

public struct ModifyUserInformationViewModelInputValue {
    
    public init(
        nicknameEditingEnd: AnyPublisher<String, Never>,
        registerTap: AnyPublisher<Void, Never>
    ) {
        self.nicknameEditingEnd = nicknameEditingEnd
        self.registerTap = registerTap
    }
    
    public let nicknameEditingEnd: AnyPublisher<String, Never>
    public let registerTap: AnyPublisher<Void, Never>
}

public protocol ModifyUserInformationViewModelInput {
    var jobSubject: PassthroughSubject<Job, Never> { get }
    func input(_ input: ModifyUserInformationViewModelInputValue)
}

public protocol ModifyUserInformationViewModelOutput {
    var nicknameLimitCount: Int { get }
    var nicknameVerification: PassthroughSubject<Verification, Never> { get }
    var jobSubject: PassthroughSubject<Job, Never> { get }
    var canMove: CurrentValueSubject<Bool, Never> { get }
    var successRegister: (() -> Void)? { get set }
}
