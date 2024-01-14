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
import Domain
import Core

public final class SignUpViewController: BaseViewController<BaseHeaderView, SignUpView, DefaultOnboardingCoordinator> {
    
    public init(viewModel: any SignUpViewModel){
        self.viewModel = viewModel
        super.init(headerView: HeaderView(title: "회원정보 입력"), mainView: SignUpView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: any SignUpViewModel
    
    public override func initialize() {
        
        setNicknameLimitCount()
        addJobMenu()
        
        func addJobMenu() {
            mainView.jobView.contentView.menu = {
                let children = Job.allCases.reversed().map{ type in
                    let action = UIAction(title: type.rawValue, handler: { action in
                        self.viewModel.jobSubject.send(type)
                    })
                    return action
                }
                return UIMenu(title: "", children: children)
            }()
        }
        
        func setNicknameLimitCount() {
            mainView.nicknameView.contentView.limitCount = viewModel.nicknameLimitCount
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    public override func bind() {
        
        input()
        bindNicknameValidation()
        bindBirthdayValidation()
        bindJobSelection()
        bindCanMove()
        bindMoveNext()
        bindError()
        
        func input() {
            viewModel.input(
                SignUpViewModelInputValue(
                    nicknameEditingEnd: mainView.nicknameView.contentView.textField.publisher(for: .editingDidEnd),
                    birthdayEditingEnd: mainView.birthdayView.contentView.textField.publisher(for: .editingDidEnd),
                    gender: mainView.genderView.contentView.elementPublisher,
                    moveNext: mainView.ctaButton.tapPublisher
                )
            )
        }
        
        func bindNicknameValidation() {
            viewModel.nicknameValidation
                .sink{ [weak self] (isValid, message) in
                    guard let self = self else { return }
                    if let message = message {
                        self.mainView.nicknameView.contentView.error(message: message)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func bindBirthdayValidation() {
        viewModel.birthdayValidation
            .sink{ [weak self] (isValid, message) in
                guard let self = self else { return }
                if let message = message {
                    self.mainView.birthdayView.contentView.error(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    func bindJobSelection() {
        viewModel.jobSubject
            .sink{ [weak self] job in
                self?.mainView.jobView.contentView.update(text: job.rawValue)
            }
            .store(in: &cancellables)
    }
    
    func bindCanMove() {
        viewModel.canMove
            .sink{ [weak self] canMove in
                guard let self = self else { return }
                self.mainView.ctaButton.isEnabled = canMove
            }
            .store(in: &cancellables)
    }
    
    func bindMoveNext() {
        viewModel.moveNext = {
            DispatchQueue.main.async{
                self.coordinator?.startTermsBottomSheet()
            }
        }
    }
    
    func bindError() {
        viewModel.errorHandler
            .receive(on: DispatchQueue.main)
            .sink{ error in
                ToastMessage.shared.register(message: error.message)
            }
            .store(in: &cancellables)
    }
}
