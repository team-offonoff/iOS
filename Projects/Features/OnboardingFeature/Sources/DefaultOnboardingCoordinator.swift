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
    
    private var window: UIWindow?
    private let navigationController: UINavigationController
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
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
}
