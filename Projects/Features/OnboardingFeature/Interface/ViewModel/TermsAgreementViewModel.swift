//
//  TermsAgreementViewModel.swift
//  OnboardingFeatureInterface
//
//  Created by 박소윤 on 2024/01/13.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import FeatureDependency
import Domain

public typealias TermsAgreementViewModel = TermsAgreementViewModelInput & TermsAgreementViewModelOutput

public protocol TermsAgreementViewModelInput {
    func toggleAll()
    func toggle(term: Term)
    func register()
}

public protocol TermsAgreementViewModelOutput {
    var allAgreementSubject: CurrentValueSubject<Bool, Never> { get }
    var serviceUseSubject: CurrentValueSubject<Bool, Never> { get }
    var privacySubject: CurrentValueSubject<Bool, Never> { get }
    var marketingSubject: CurrentValueSubject<Bool, Never> { get }
    var canMove: CurrentValueSubject<Bool, Never> { get }
    var successRegister: (() -> Void)? { get set }
}
