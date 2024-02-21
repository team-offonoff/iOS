//
//  DefaultSideACoordinator.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import SideAFeatureInterface
import CommentFeatureInterface
import CommentFeature
import Domain
import Data

public final class DefaultSideACoordinator: SideACoordinator {

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
    
    public func start() {
        let viewController = SideAViewController(
            viewModel: DefaultSideAViewModel(
                fetchTopicsUseCase: DefaultFetchTopicsUseCase(repository: topicRepository),
                voteTopicUseCase: DefaultGenerateVoteUseCase(repository: topicRepository)
            )
        )
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    public func startCommentBottomSheet(topicId: Int, choices: [Choice.Option : Choice]) {
        commentCoordinator.startCommentBottomSheet(topicId: topicId, choices: choices)
    }
    
}
