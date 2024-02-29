//
//  DefaultMyPageCoordinator.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import MyPageFeatureInterface
import UIKit
import Domain
import Data

public final class DefaultMyPageCoordinator: MyPageCoordinator {
    
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
    private let memberRepository: any MemberRepository = DefaultMemberRepository()
    private lazy var myPageViewModel: MyPageViewModel = DefaultMyPageViewModel(
        fetchProfileUseCase: DefaultFetchProfileUseCase(repository: memberRepository),
        modifyProfileImageUseCase: DefaultModifyProfileImageUseCase(repository: memberRepository),
        deleteProfileImageUseCase: DefaultDeleteProfileImageUseCase(repository: memberRepository)
    )
    public func start() {
        let viewController = MyPageViewController(viewModel: myPageViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startModifyInformation(profile: Profile) {
        let viewController = ModifyUserInformationViewController(viewModel: DefaultModifyUserInformationViewModel(profile: profile, modifyInformationUseCase: DefaultModifyMemberInformationUseCase(repository: DefaultMemberRepository())))
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startProfileImageActionBottomSheet() {
        let bottomSheetViewController = ProfileImageActionBottomSheetViewController()
        bottomSheetViewController.coordinator = self
        navigationController.present(bottomSheetViewController, animated: true)
    }
    
    public func startDeleteProfileImageBottomSheet() {
        let bottomSheetViewController = ProfileImageDeleteBottomSheetViewController(viewModel: myPageViewModel)
        navigationController.present(bottomSheetViewController, animated: true)
    }
    
    public func startTerm() {
        let viewController = TermListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startLogout() {
        (sceneDelegate as? MyPageSceneDelegate)?.sceneMoveToOnboarding()
    }
}
