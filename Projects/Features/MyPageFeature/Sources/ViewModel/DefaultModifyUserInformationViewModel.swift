//
//  DefaultModifyUserInformationViewModel.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine
import MyPageFeatureInterface
import FeatureDependency
import Domain
import Core

final class DefaultModifyUserInformationViewModel: ModifyUserInformationViewModel {

    init(
        profile: Profile,
        modifyInformationUseCase: any ModifyMemberInformationUseCase
    ) {
        self.profile = profile
        self.modifyInformationUseCase = modifyInformationUseCase
        super.init()
    }
    
    private let modifyInformationUseCase: any ModifyMemberInformationUseCase
    
    let profile: Profile
    let nicknameVerification: PassthroughSubject<Verification, Never> = PassthroughSubject()
    let jobSubject: PassthroughSubject<Job, Never> = PassthroughSubject()
    let canMove: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var successRegister: (() -> Void)?
    
    private var requestValue: ModifyMemberInformationUseCaseRequestValue?
    
    func input(_ input: ModifyUserInformationViewModelInputValue) {
        
        input.nicknameEditingEnd
            .sink{ [weak self] nickname in
                
                guard let self = self else { return }
                
                self.nicknameVerification.send(verification())
                
                func verification() -> Verification {
                    if Regex.validate(data: nickname, pattern: .nickname) {
                        return .init(data: nickname, isValid: true, errorMessage: nil)
                    }
                    return .init(data: nickname, isValid: false, errorMessage: "* 한글, 영문, 숫자만 가능해요.")
                }
            }
            .store(in: &cancellable)
        
        nicknameVerification
            .combineLatest(jobSubject)
            .sink{ [weak self] nicknameVerification, job in

                guard let self = self, let nickname = nicknameVerification.data as? String else { return }
                self.requestValue = .init(nickname: nickname, job: job)
                self.canMove.send(canMove())

                func canMove() -> Bool {
                    nicknameVerification.isValid
                }
            }
            .store(in: &cancellable)
        
        input.registerTap
            .compactMap{ [weak self] _ in
                self?.requestValue
            }
            .flatMap{ requestValue in
                self.modifyInformationUseCase.execute(request: requestValue)
            }
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.successRegister?()
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
                
            }
            .store(in: &cancellable)
    }
    
}
