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

final class DefaultModifyUserInformationViewModel: BaseViewModel, ModifyUserInformationViewModel {
    
    let nicknameValidation: PassthroughSubject<(Bool, String?), Never> = PassthroughSubject()
    let jobSubject: PassthroughSubject<Job, Never> = PassthroughSubject()
    let canMove: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    let nicknameLimitCount: Int = 8
    
    var successRegister: (() -> Void)?
    
    func input(_ input: ModifyUserInformationViewModelInputValue) {
        
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
        
        nicknameValidation
            .combineLatest(jobSubject)
            .sink{ [weak self] nickname, job in
                
                guard let self = self else { return }
                
                self.canMove.send(canMove())
                
                func canMove() -> Bool {
                    nickname.0
                }
            }
            .store(in: &cancellable)
        
//        input.registerTap
//            .flatMap{
//
//            }
//            .sink{
//
//            }
//            .store(in: &cancellable)
    }
    
}
