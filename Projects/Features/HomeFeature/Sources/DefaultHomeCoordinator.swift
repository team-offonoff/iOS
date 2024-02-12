//
//  DefaultHomeCoordinator.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import HomeFeatureInterface
import CommentFeatureInterface
import TopicFeature
import CommentFeature
import Domain
import Data

public class DefaultHomeCoordinator: HomeCoordinator {
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.commentCoordinator = DefaultCommentCoordinator(navigationController: navigationController)
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
        self.commentCoordinator = DefaultCommentCoordinator(navigationController: navigationController)
    }
    
    private var window: UIWindow?
    private let navigationController: UINavigationController
    private let commentCoordinator: CommentCoordinator
    private let topicRepository: TopicRepository = DefaultTopicRepository()
    private lazy var homeViewModel: HomeTabViewModel = generateHomeViewModel()
    
    private func generateHomeViewModel() -> HomeTabViewModel {
        
        return DefaultHomeTabViewModel(
            fetchTopicsUseCase: getFetchTopicsUseCase(),
            reportTopicUseCase: getReportTopicUseCase(),
            voteTopicUseCase: getVoteTopicUseCase(),
            revoteTopicUseCase: getRevoteTopicUseCase()
        )
        
        func getFetchTopicsUseCase() -> any FetchTopicsUseCase {
            DefaultFetchTopicsUseCase(repository: topicRepository)
        }
        
        func getReportTopicUseCase() -> any ReportTopicUseCase {
            DefaultReportTopicUseCase(repository: topicRepository)
        }
        
        func getVoteTopicUseCase() -> any GenerateVoteUseCase {
            DefaultGenerateVoteUseCase(repository: topicRepository)
        }
        
        func getRevoteTopicUseCase() -> any RevoteUseCase {
            DefaultRevoteUseCase(repository: topicRepository)
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
    
    public func startCommentBottomSheet(topicId: Int, choices: [Choice.Option: Choice]) {
        commentCoordinator.startCommentBottomSheet(topicId: topicId, choices: choices)
    }
    
    public func startImagePopUp(choice: Choice) {
        let popUpViewController = TopicImagePopUpViewController(choice: choice)
        popUpViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(popUpViewController, animated: false)
    }
    
    public func startAlarm() {
        let viewController = AlarmViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
