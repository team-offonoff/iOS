//
//  DefaultTopicCoordinator.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import TopicFeatureInterface
import Domain
import Data

public class DefaultTopicGenerateCoordinator: TopicGenerateCoordinator {
    
    required public init(window: UIWindow?){
        self.window = window
    }
    
    public init(rootViewController: UIViewController){
        self.rootViewController = rootViewController
    }
    
    private var window: UIWindow?
    private var rootViewController: UIViewController?
    private lazy var navigationController: UINavigationController = {
        let viewController = TopicSideChoiceViewController()
        viewController.coordinator = self
        return UINavigationController(rootViewController: viewController)
    }()
    
    public func start() {
        if window != nil {
            self.window?.rootViewController = navigationController
        }
        navigationController.modalPresentationStyle = .overFullScreen
        rootViewController?.present(navigationController, animated: true)
    }
}
