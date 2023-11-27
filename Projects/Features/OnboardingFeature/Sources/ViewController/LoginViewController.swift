//
//  LoginViewController.swift
//  OnboardingFeatureDemo
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import OnboardingFeatureInterface
import AuthenticationServices

class LoginViewController: BaseViewController<BaseHeaderView, LoginView, DefaultOnboardingCoordinator> {
    
    private var viewModel: any LoginViewModel
    
    init(viewModel: any LoginViewModel){
        self.viewModel = viewModel
        super.init(headerView: BaseHeaderView(), mainView: LoginView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var appleAuthorizationController: ASAuthorizationController = {
        let authorizationController = ASAuthorizationController(authorizationRequests: viewModel.makeAppleRequests())
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        return authorizationController
    }()
    
    override func initialize() {
        addButtonFrameElementsTarget()
    }
    
    private func addButtonFrameElementsTarget(){
        mainView.buttonFrame.kakaoLoginButton.addTarget(self, action: #selector(startKakaoLogin), for: .touchUpInside)
        mainView.buttonFrame.appleLoginButton.addTarget(self, action: #selector(startAppleLogin), for: .touchUpInside)
    }
    
    override func bind() {
        viewModel.moveHome = {
            DispatchQueue.main.async { [weak self] in
                self?.coordinator?.startHome()
            }
        }
        viewModel.moveSignUp = {
            DispatchQueue.main.async { [weak self] in
                self?.coordinator?.startSignUp()
            }
        }
    }
    
    @objc private func startKakaoLogin(){
        viewModel.startKakaoLogin()
    }
    
    @objc private func startAppleLogin(){
        appleAuthorizationController.performRequests()
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            viewModel.startAppleLogin(credential: appleIDCredential)
        default: return
        }
    }
}
