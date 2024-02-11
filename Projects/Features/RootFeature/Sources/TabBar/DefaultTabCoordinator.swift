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

public class DefaultTabCoordinator: TabCoordinator {
    
    private let window: UIWindow?
    private let tabBarController: TabBarController
    private let homeTabNavigationController: UINavigationController
    private let abTabNavigationController: UINavigationController
    private let newTabNavigationController: UINavigationController
    private let userTabNavigationController: UINavigationController
    
    required public init(
        window: UIWindow?
    ){
        self.window = window
        self.tabBarController = TabBarController()
        self.homeTabNavigationController = UINavigationController()
        self.abTabNavigationController = UINavigationController()
        self.newTabNavigationController = UINavigationController()
        self.userTabNavigationController = UINavigationController()
    }
    
    private var coordinators: [Coordinator] = []
    private var topicGenerateCoordinator: TopicGenerateCoordinator?
    
    public func start() {
        window?.rootViewController = tabBarController
        tabBarController.coordinator = self
        setTabBarViewControllers()
        startHome()
        startAB()
        startNew()
        startUser()
    }
    
    private func setTabBarViewControllers(){
        
        let tabs: [UINavigationController] = [
            homeTabNavigationController,
            abTabNavigationController,
            newTabNavigationController,
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
    
    private func startAB() {
//        let abCoordinator: HomeCoordinator = DefaultHomeCoordinator(navigationController: abTabNavigationController)
//        abCoordinator.start()
    }
    
    private func startNew(){
//        let newCoordinator: HomeCoordinator = DefaultHomeCoordinator(navigationController: newTabNavigationController)
//        newCoordinator.start()
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
