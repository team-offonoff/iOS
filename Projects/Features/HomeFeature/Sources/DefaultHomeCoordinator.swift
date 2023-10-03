//
//  DefaultHomeCoordinator.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import FeatureDependency

public class DefaultHomeCoordinator: HomeCoordinator {
    
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    public func start() {
        let viewController = HomeTabViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
