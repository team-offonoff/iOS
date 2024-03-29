//
//  DefaultCommentCoordinator.swift
//  CommentFeature
//
//  Created by 박소윤 on 2024/01/08.
//  Copyright © 2024 AB. All rights reserved.
//

import UIKit
import ABKit
import CommentFeatureInterface
import Domain
import Data

public class DefaultCommentCoordinator: CommentCoordinator {
    
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
    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private var commentBottomSheet: CommentBottomSheetViewController?
    private var commentViewModel: CommentBottomSheetViewModel?
    
    public func startCommentBottomSheet(topicId: Int, choices: [Choice.Option: Choice]) {
        
        commentBottomSheet = CommentBottomSheetViewController(viewModel: viewModel())
        start()
        
        func viewModel() -> CommentBottomSheetViewModel {
            commentViewModel = DefaultCommentBottomSheetViewModel(
                topicId: topicId,
                choices: choices,
                generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
                fetchCommentsUseCase: DefaultFetchCommentsUseCase(repository: commentRepository),
                patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
                patchCommentLikeUseCase: DefaultPatchCommentLikeStateUseCase(repository: commentRepository),
                patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
                deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
            )
            return commentViewModel!
        }
    }
    
    public func start() {
        guard let commentBottomSheet = commentBottomSheet else { return }
        commentBottomSheet.coordinator = self
        commentBottomSheet.modalPresentationStyle = .custom
        navigationController.present(commentBottomSheet, animated: true)
    }
    
    public func startWritersBottomSheet(index: Int) {
        guard let viewModel = commentViewModel else { return }
        commentBottomSheet?.present(WritersCommentBottomSheetViewController(index: index, viewModel: viewModel), animated: true)
    }
    
    public func startOthersBottomSheet(index: Int) {
        guard let viewModel = commentViewModel else { return }
        commentBottomSheet?.present(OthersCommnetBottomSheetViewController(index: index, viewModel: viewModel), animated: true)
    }
    
    public func startDeleteBottomSheet(index: Int) {
        guard let viewModel = commentViewModel else { return }
        commentBottomSheet?.present(DeleteBottomSheetViewController(title: "내가 작성한 댓글을 삭제합니다.", index: index, viewModel: viewModel), animated: true)
    }
}
