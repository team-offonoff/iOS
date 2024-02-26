//
//  DefaultTabCoordinator.swift
//  RootFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import FeatureDependency
import HomeFeatureInterface
import TopicGenerateFeatureInterface
import MyPageFeatureInterface
import HomeFeature
import TopicGenerateFeature
import TopicFeature
import MyPageFeature
import SideAFeatureInterface
import SideBFeatureInterface
import SideAFeature
import SideBFeature

public class DefaultTabCoordinator: TabCoordinator {
    
    private let window: UIWindow?
    private let tabBarController: TabBarController
    private let homeTabNavigationController: UINavigationController
    private let aSideTabNavigationController: UINavigationController
    private let bSideTabNavigationController: UINavigationController
    private let userTabNavigationController: UINavigationController
    
    required public init(
        window: UIWindow?
    ){
        self.window = window
        self.tabBarController = TabBarController()
        self.homeTabNavigationController = UINavigationController()
        self.aSideTabNavigationController = UINavigationController()
        self.bSideTabNavigationController = UINavigationController()
        self.userTabNavigationController = UINavigationController()
    }
    
    private var coordinators: [Coordinator] = []
    private var topicGenerateCoordinator: TopicGenerateCoordinator?
    
    public func start() {
        window?.rootViewController = tabBarController
        tabBarController.coordinator = self
        setTabBarViewControllers()
        startHome()
        startAside()
        startBside()
        startUser()
    }
    
    private func setTabBarViewControllers(){
        
        let tabs: [UINavigationController] = [
            homeTabNavigationController,
            aSideTabNavigationController,
            bSideTabNavigationController,
            userTabNavigationController
        ]
        
        tabBarController.setViewControllers(tabs, animated: true)
        tabBarController.selectedIndex = 0
    }
    
    private func startHome() {
        let homeCoordinator: HomeCoordinator = DefaultHomeCoordinator(navigationController: homeTabNavigationController)
        coordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    private func startAside() {
        let aSideCoordinator: SideACoordinator = DefaultSideACoordinator(navigationController: aSideTabNavigationController)
        coordinators.append(aSideCoordinator)
        aSideCoordinator.start()
    }
    
    private func startBside(){
        let bSideCoordinator: SideBCoordinator = DefaultSideBCoordinator(navigationController: bSideTabNavigationController)
        coordinators.append(bSideCoordinator)
        bSideCoordinator.start()
    }
    
    private func startUser(){
        let userCoordinator: MyPageCoordinator = DefaultMyPageCoordinator(navigationController: userTabNavigationController)
        coordinators.append(userCoordinator)
        userCoordinator.start()
    }

    public func startTopicGenerate() {
        topicGenerateCoordinator = DefaultTopicGenerateCoordinator(rootViewController: tabBarController)
        topicGenerateCoordinator?.start()
    }
}
