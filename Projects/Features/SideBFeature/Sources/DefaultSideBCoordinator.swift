//
//  DefaultSideBCoordinator.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import SideBFeatureInterface
import CommentFeatureInterface
import CommentFeature
import TopicFeature
import Domain
import Data

public final class DefaultSideBCoordinator: SideBCoordinator {

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
    private let topicRepository: any TopicRepository = DefaultTopicRepository()
    private let commentRepository: any CommentRepository = DefaultCommentRepository()
    private lazy var sideBViewModel: any SideBViewModel = DefaultSideBViewModel(
        fetchTopicsUseCase: DefaultFetchTopicsUseCase(repository: topicRepository),
        voteTopicUseCase: DefaultGenerateVoteUseCase(repository: topicRepository),
        hideTopicUseCase: DefaultHideTopicUseCase(repository: topicRepository),
        revoteTopicUseCase: DefaultRevoteUseCase(repository: topicRepository),
        reportTopicUseCase: DefaultReportTopicUseCase(repository: topicRepository)
    )
    
    public func start() {
        let viewController = SideBViewController(viewModel: sideBViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startTopicDetail(index: Int) {
        sideBViewModel.topicIndex = index
        let viewController = SideBTopicDetailViewController(viewModel: sideBViewModel)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startTopicBottomSheet() {
        navigationController.present(TopicBottomSheetViewController(viewModel: sideBViewModel), animated: true)
    }
    
    public func startCommentBottomSheet(topicId: Int, choices: [Choice.Option : Choice]) {
        commentCoordinator.startCommentBottomSheet(topicId: topicId, choices: choices)
    }
    
}
