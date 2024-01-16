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
import Domain

public typealias ModifyUserInformationViewModel = ModifyUserInformationViewModelInput & ModifyUserInformationViewModelOutput

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
    var nicknameValidation: PassthroughSubject<(Bool, String?), Never> { get }
    var jobSubject: PassthroughSubject<Job, Never> { get }
    var canMove: CurrentValueSubject<Bool, Never> { get }
    var successRegister: (() -> Void)? { get set }
}
