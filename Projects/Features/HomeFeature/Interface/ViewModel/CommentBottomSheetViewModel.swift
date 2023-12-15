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

public typealias CommentBottomSheetViewModel = CommentBottomSheetViewModelInput & CommentBottomSheetViewModelOutput & ErrorHandleable

public protocol CommentBottomSheetViewModelInput {
    func fetchComments()
    func toggleLikeState(at index: Int)
    func toggleDislikeState(at index: Int)
    func delete(at index: Int)
}

public protocol CommentBottomSheetViewModelOutput {
    var comments: [CommentListItemViewModel] { get }
    var commentsCountTitle: String { get }
    var reloadData: (() -> Void)? { get set }
    var toggleLikeState: PassthroughSubject<Index, Never> { get }
    var toggleDislikeState: PassthroughSubject<Index, Never> { get }
    var deleteItem: PassthroughSubject<Index, Never> { get }
}
