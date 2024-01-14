//
//  DefaultTermsAgreementViewModel.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2024/01/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import OnboardingFeatureInterface
import FeatureDependency
import Domain

final class DefaultTermsAgreementViewModel: BaseViewModel, TermsAgreementViewModel {
    
    let allAgreementSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let serviceUseSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let privacySubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    let marketingSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    let canMove: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var successRegister: (() -> Void)?
    
    override func bind() {
        
        serviceUseSubject.combineLatest(privacySubject, marketingSubject)
            .sink{ [weak self] service, privacy, marketing in
                
                guard let self = self else { return }
                
                self.canMove.send(isEssentialSatisfy())
                
                if [service, privacy, marketing].allSatisfy({ $0 == true }) {
                    self.allAgreementSubject.send(true)
                }
                else {
                    self.allAgreementSubject.send(false)
                }
                
                func isEssentialSatisfy() -> Bool {
                    service && privacy
                }
            }
            .store(in: &cancellable)
    }
    
    func toggleAll() {
        let newValue = !allAgreementSubject.value
        [serviceUseSubject, privacySubject, marketingSubject].forEach{
            $0.send(newValue)
        }
    }
    
    func toggle(term: Term) {
        switch term {
        case .serviceUse:   serviceUseSubject.send(!serviceUseSubject.value)
        case .privacy:      privacySubject.send(!privacySubject.value)
        case .marketing:    marketingSubject.send(!marketingSubject.value)
        }
    }
}
