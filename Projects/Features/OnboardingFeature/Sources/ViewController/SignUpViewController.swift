//
//  SignUpViewController.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import OnboardingFeatureInterface

public final class SignUpViewController: BaseViewController<BaseHeaderView, SignUpView, DefaultOnboardingCoordinator> {
    
    public init(viewModel: any SignUpViewModel){
        self.viewModel = viewModel
        super.init(headerView: HeaderView(title: "회원정보 입력"), mainView: SignUpView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any SignUpViewModel
    
    public override func initialize() {
        setNicknameLimitCount()
        mainView.jobView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showBottomSheet)))
        
        func setNicknameLimitCount() {
            mainView.nicknameView.contentView.limitCount = viewModel.nicknameLimitCount
        }
    }
    
    @objc private func showBottomSheet() {

    }
    
    public override func bind() {
        
        input()
        bindNicknameValidation()
        
        func input() {
            viewModel.input(
                SignUpViewModelInputValue(
                    nicknameEditingEnd: mainView.nicknameView.contentView.textField.publisher(for: .editingDidEnd)
                )
                
            )
        }
        
        func bindNicknameValidation() {
            viewModel.nicknameValidation
                .sink{ [weak self] (isValid, message) in
                    guard let self = self else { return }
                    if isValid {
                        self.mainView.nicknameView.contentView.setComplete()
                    }
                    else if let message = message {
                        self.mainView.nicknameView.contentView.error(message: message)
                    }
                }
                .store(in: &cancellables)
        }
    }
}
