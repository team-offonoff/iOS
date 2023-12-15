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
        super.init(headerView: nil, mainView: LoginView())
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
    
    override func style() {
        view.backgroundColor = Color.background
    }
    
    override func initialize() {
        addButtonFrameElementsTarget()
    }
    
    private func addButtonFrameElementsTarget(){
        mainView.buttonGroup.kakaoLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startKakaoLogin)))
        mainView.buttonGroup.appleLogin.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startAppleLogin)))
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
    
    @objc private func startKakaoLogin(_ recognizer: UITapGestureRecognizer){
        recognizer.view
            .publisher
            .sink{ [weak self] _ in
                self?.viewModel.startKakaoLogin()
            }
            .store(in: &cancellables)
    }
    
    @objc private func startAppleLogin(_ recognizer: UITapGestureRecognizer){
        recognizer.view
            .publisher
            .sink{ [weak self] _ in
                self?.appleAuthorizationController.performRequests()
            }
            .store(in: &cancellables)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        viewModel.startAppleLogin(credential: appleIDCredential)
    }
}
