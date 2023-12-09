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
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    private lazy var homeViewModel: HomeTabViewModel = generateHomeViewModel()
    
    private let topicRepository: TopicRepository = DefaultTopicRepository()
    
    private func generateHomeViewModel() -> HomeTabViewModel {
        
        return DefaultHomeTabViewModel(
            fetchTopicsUseCase: getFetchTopicsUseCase(),
            reportTopicUseCase: getReportTopicUseCase()
        )
        
        func getFetchTopicsUseCase() -> any FetchTopicsUseCase {
            DefaultFetchTopicsUseCase(repository: topicRepository)
        }
        
        func getReportTopicUseCase() -> any ReportTopicUseCase {
            DefaultReportTopicUseCase(repository: topicRepository)
        }
    }
    
    public func start() {
        let viewController = HomeTabViewController(viewModel: homeViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startTopicBottomSheet() {
        navigationController.present(TopicBottomSheetViewController(viewModel: homeViewModel), animated: true)
    }
    
    public func startChatBottomSheet() {
        navigationController.present(ChatBottomSheetViewController(), animated: true)
    }
}
