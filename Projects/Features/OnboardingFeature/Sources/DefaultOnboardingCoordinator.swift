//
//  DefaultOnboardingCoordinator.swift
//  OnboardingFeatureDemo
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import OnboardingFeatureInterface
import Domain
import Data

public class DefaultOnboardingCoordinator: OnboardingCoordinator {
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    private var window: UIWindow?
    
    private let navigationController: UINavigationController
    private let authRepository: AuthRepository = DefaultAuthRepository()
    
    public func start() {
        
        let viewController = LoginViewController(viewModel: getViewModel())
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)

        func getViewModel() -> LoginViewModel {
            DefaultLoginViewModel(loginUseCase: getLoginUseCase())
        }
        
        func getLoginUseCase() -> any LoginUseCase {
            DefaultLoginUseCase(repository: getOAuthRepository())
        }
        
        func getOAuthRepository() -> OAuthRepository {
            DefaultOAuthRepository()
        }
    }
    
    public func startSignUp() {
        
        let viewController = SignUpViewController(viewModel: getViewModel())
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
        
        func getViewModel() -> SignUpViewModel {
            DefaultSignUpViewModel(signUpUseCase: DefaultGenerateProfileUseCase(repository: authRepository))
        }
    }
    
    public func startTermsBottomSheet() {
        
        let bottomSheetViewController = TermsAgreementBottomSheetViewController(viewModel: viewModel())
        bottomSheetViewController.coordinator = self
        navigationController.present(bottomSheetViewController, animated: true)
        
        func viewModel() -> TermsAgreementViewModel {
            DefaultTermsAgreementViewModel(registerTermsUseCase: useCase())
        }
        
        func useCase() -> any RegisterTersmUseCase {
            DefaultRegisterTersmUseCase(repository: authRepository)
        }
    }
    
    public func startHome() {
        (sceneDelegate as? OnboardingSceneDelegate)?.sceneMoveToRootFeature()
    }
}
