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
    
    required public init(window: UIWindow?){
        self.window = window
        self.navigationController = UINavigationController()
        self.window?.rootViewController = navigationController
    }
    
    public init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    private var window: UIWindow?
    private var commentBottomSheet: CommentBottomSheetViewController?
    private var commentBottomSheetViewModel: CommentBottomSheetViewModel?
    private let navigationController: UINavigationController
    private let topicRepository: TopicRepository = DefaultTopicRepository()
    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private lazy var homeViewModel: HomeTabViewModel = generateHomeViewModel()
    
    private func generateHomeViewModel() -> HomeTabViewModel {
        
        return DefaultHomeTabViewModel(
            fetchTopicsUseCase: getFetchTopicsUseCase(),
            reportTopicUseCase: getReportTopicUseCase(),
            voteTopicUseCase: getVoteTopicUseCase(),
            cancelVoteTopicUseCase: getCancelVoteTopicUseCase()
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
        
        func getCancelVoteTopicUseCase() -> any CancelVoteUseCase {
            DefaultCancelVoteUseCase(repository: topicRepository)
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
    
    public func startCommentBottomSheet(standard: CGFloat, topicId: Int) {
        
        commentBottomSheet = CommentBottomSheetViewController(standard: standard, viewModel: viewModel())
        commentBottomSheet?.coordinator = self
        commentBottomSheet?.modalPresentationStyle = .custom
        if let commentBottomSheet = commentBottomSheet {
            navigationController.present(commentBottomSheet, animated: true)
        }
        
        func viewModel() -> CommentBottomSheetViewModel {
            commentBottomSheetViewModel = DefaultCommentBottomSheetViewModel(
                topicId: topicId,
                generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
                fetchCommentsUseCase: DefaultFetchCommentsUseCase(repository: commentRepository),
                patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
                patchCommentLikeUseCase: DefaultPatchCommentLikeStateUseCase(repository: commentRepository),
                patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
                deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
            )
            return commentBottomSheetViewModel!
        }
    }
    
    public func startImagePopUp(choice: Choice) {
        let popUpViewController = ImagePopUpViewController(choice: choice)
        popUpViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(popUpViewController, animated: false)
    }
    
    public func startWritersBottomSheet(index: Int) {
        guard let viewModel = commentBottomSheetViewModel else { return }
        commentBottomSheet?.present(WritersCommentBottomSheetViewController(index: index, viewModel: viewModel), animated: true)
    }
    
    public func startOthersBottomSheet(index: Int) {
        guard let viewModel = commentBottomSheetViewModel else { return }
        commentBottomSheet?.present(OthersCommnetBottomSheetViewController(index: index, viewModel: viewModel), animated: true)
    }
}
