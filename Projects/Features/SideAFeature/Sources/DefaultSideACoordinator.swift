//
//  DefaultSideACoordinator.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import SideAFeatureInterface
import UIKit

public final class DefaultSideACoordinator: SideACoordinator {

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
    
    public func start() {
        navigationController.pushViewController(SideAViewController(), animated: true)
    }
    
}
