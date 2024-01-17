//
//  ModifyUserInformationViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import MyPageFeatureInterface
import FeatureDependency
import Domain

final class ModifyUserInformationViewController: BaseViewController<NavigateHeaderView, ModifyUserInformationView, DefaultMyPageCoordinator> {
    
    init(viewModel: any ModifyUserInformationViewModel) {
        self.viewModel = viewModel
        super.init(headerView: NavigateHeaderView(title: "내 정보 수정"), mainView: ModifyUserInformationView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: any ModifyUserInformationViewModel
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func initialize() {

        jobMenu()
        nicknameLimitCount()
        
        func jobMenu() {
            mainView.jobView.contentView.menu = {
                let children = Job.allCases.map{ type in
                    let action = UIAction(title: type.rawValue, handler: { action in
                        self.viewModel.jobSubject.send(type)
                    })
                    return action
                }
                return UIMenu(title: "", children: children)
            }()
        }
        
        func nicknameLimitCount() {
            mainView.nicknameView.contentView.limitCount = viewModel.nicknameLimitCount
        }
    }
    
    override func bind() {
        
        input()
        bindNicknameValidation()
        bindJobSelection()
        bindCanMove()
        bindSuccessRegister()
        
        func input() {
            viewModel.input(
                ModifyUserInformationViewModelInputValue(
                    nicknameEditingEnd: mainView.nicknameView.contentView.textField.publisher(for: .editingDidEnd),
                    registerTap: mainView.ctaButton.tapPublisher
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
        
        func bindSuccessRegister() {
            viewModel.successRegister = {
                DispatchQueue.main.async{
                   
                }
            }
        }
    }
}
