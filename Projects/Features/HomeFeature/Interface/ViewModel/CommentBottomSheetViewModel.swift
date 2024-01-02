//
//  CommentBottomSheetViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core
import FeatureDependency
import Combine

public typealias CommentBottomSheetViewModel = CommentBottomSheetViewModelInput & CommentBottomSheetViewModelOutput & ErrorHandleable & WritersCommentBottomSheetViewModel & OthersCommentBottomSheetViewModel
public typealias WritersCommentBottomSheetViewModel = WritersCommentBottomSheetViewModelInput & WritersCommentBottomSheetViewModelOutput
public typealias OthersCommentBottomSheetViewModel = OthersCommentBottomSheetViewModelInput & OthersCommentBottomSheetViewModelOutput

public protocol CommentBottomSheetViewModelInput {
    func fetchComments()
    func generateComment(content: String)
    func toggleLikeState(at index: Int)
    func toggleDislikeState(at index: Int)
}

public protocol CommentBottomSheetViewModelOutput {
    var comments: [CommentListItemViewModel] { get }
    var commentsCountTitle: String { get }
    var reloadData: (() -> Void)? { get set }
    var generateItem: PassthroughSubject<Void, Never> { get }
    var toggleLikeState: PassthroughSubject<Index, Never> { get }
    var toggleDislikeState: PassthroughSubject<Index, Never> { get }
    func isWriterItem(at index: Int) -> Bool
}

public protocol WritersCommentBottomSheetViewModelInput {
    func modifyComment(at index: Int, content: String)
    func delete(at index: Int)
}

public protocol WritersCommentBottomSheetViewModelOutput {
    var modifyItem: PassthroughSubject<Index, Never> { get }
    var deleteItem: PassthroughSubject<Index, Never> { get }
}

public protocol OthersCommentBottomSheetViewModelInput {
    func report(at index: Int)
}

public protocol OthersCommentBottomSheetViewModelOutput {
    var reportItem: PassthroughSubject<Index, Never> { get }
}




