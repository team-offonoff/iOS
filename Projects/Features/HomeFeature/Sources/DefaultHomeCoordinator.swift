//
//  DefaultHomeCoordinator.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import HomeFeatureInterface
import Domain
import Data

public class DefaultHomeCoordinator: HomeCoordinator {
    
    private var window: UIWindow?
    private let navigationController: UINavigationController
    
    private let topicRepository: TopicRepository = DefaultTopicRepository()
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    public func start() {
        
        let viewController = HomeTabViewController(viewModel: getHomeTabViewModel())
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
        
        func getHomeTabViewModel() -> HomeTabViewModel {
            DefaultHomeTabViewModel(fetchTopicsUseCase: getFetchTopicsUseCase())
        }
        
        func getFetchTopicsUseCase() -> any FetchTopicsUseCase {
            DefaultFetchTopicsUseCase(repository: topicRepository)
        }
    }
}
