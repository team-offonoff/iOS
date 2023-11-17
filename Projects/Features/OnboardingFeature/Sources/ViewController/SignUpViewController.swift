//
//  SignUpViewController.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import ABKit
import FeatureDependency
import OnboardingFeatureInterface

public final class SignUpViewController: BaseViewController<BaseHeaderView, SignUpView, DefaultOnboardingCoordinator> {
    
    public init(viewModel: any SignUpViewModel){
        self.viewModel = viewModel
        super.init(headerView: BaseHeaderView(), mainView: SignUpView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any SignUpViewModel
    
    public override func bind() {
        input()
    }
    
    private func input() {
        viewModel.input(
            SignUpViewModelInputValue(
                nicknamePublisher: mainView.nicknameFrame.textField.textPublisher,
                birthdayPublisher: mainView.birthdayFrame.textField.textPublisher,
                genderPublisher: mainView.genderFrame.elementPublisher
            ))
    }
}
