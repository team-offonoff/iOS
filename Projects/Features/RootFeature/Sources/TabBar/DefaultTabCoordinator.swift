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
import HomeFeature

public class DefaultTabCoordinator: TabCoordinator {
    
    private let window: UIWindow?
    private let tabBarController: UITabBarController
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
    
    public func start() {
        window?.rootViewController = tabBarController
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
        
        TabBarItem.allCases.forEach {
            tabs[$0.rawValue].tabBarItem = $0.asTabBarItem()
        }
        
        tabBarController.setViewControllers(tabs, animated: true)
        tabBarController.selectedIndex = 0
    }
    
    private func startHome() {
        let homeCoordinator: HomeCoordinator = DefaultHomeCoordinator(navigationController: homeTabNavigationController)
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
//        let userCoordinator: HomeCoordinator = DefaultHomeCoordinator(navigationController: userTabNavigationController)
//        userCoordinator.start()
    }
}
