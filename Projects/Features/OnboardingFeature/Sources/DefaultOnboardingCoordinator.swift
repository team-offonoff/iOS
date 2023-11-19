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
    private var sceneDelegate: UISceneDelegate? {
        UIApplication.shared.connectedScenes.first?.delegate
    }
    
    private let navigationController: UINavigationController
    
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
            DefaultSignUpViewModel()
        }
    }
    
    public func startHome() {
        (sceneDelegate as? OnboardingSceneDelegate)?.sceneMoveToRootFeature()
    }
}
