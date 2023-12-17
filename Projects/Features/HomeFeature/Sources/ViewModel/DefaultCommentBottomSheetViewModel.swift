//
//  DefaultCommentBottomSheetViewModel.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import FeatureDependency
import HomeFeatureInterface
import Domain
import Core

public final class DefaultCommentBottomSheetViewModel: BaseViewModel, CommentBottomSheetViewModel {

    private var pageInfo: Paging?
    private let topicId: Int
    private let fetchCommentsUseCase: any FetchCommentsUseCase
    private let patchCommentLikeUseCase: any PatchCommentLikeStateUseCase
    private let patchCommentDislikeUseCase: any PatchCommentDislikeStateUseCase
//    private let deleteCommentUseCase: any
    
    public init(
        topicId: Int,
        fetchCommentsUseCase: any FetchCommentsUseCase,
        patchCommentLikeUseCase: any PatchCommentLikeStateUseCase,
        patchCommentDislikeUseCase: any PatchCommentDislikeStateUseCase
    ) {
        self.topicId = topicId
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.patchCommentLikeUseCase = patchCommentLikeUseCase
        self.patchCommentDislikeUseCase = patchCommentDislikeUseCase
        super.init()
    }
    
    //MARK: - OUTPUT
    public var reloadData: (() -> Void)?
    public var commentsCountTitle: String { ABFormat.count(comments.count) + " 개" }
    public var comments: [CommentListItemViewModel] = []
    public let toggleLikeState: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let toggleDislikeState: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let reportItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let modifyItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let deleteItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    public func isWriterItem(at index: Int) -> Bool {
        index % 2 == 0 ? true : false //comments[index].userId == userId
    }
}

//MARK: - INPUT
extension DefaultCommentBottomSheetViewModel {
    
    public func fetchComments() {
        fetchCommentsUseCase
            .execute(topicId: topicId, page: pageInfo?.page ?? 0)
            .sink{ [weak self] result in
                guard let self = self else { return }
//                if result.isSuccess, let (pageInfo, data) = result.data {
                    //TODO: 페이징 코드 추가
//                    self.pageInfo = pageInfo
                    self.comments = [CommentListItemViewModel](repeating: .init(), count: 10)
//                    self.comments.append(contentsOf: data.map{ _ in .init() })
                    self.reloadData?()
//                }
//                else if let error = result.error {
//                    self.errorHandler.send(error)
//                }
            }
            .store(in: &cancellable)
    }
    
    public func toggleLikeState(at index: Int) {
        patchCommentLikeUseCase
            .execute(commentId: comments[index].id, isLike: !comments[index].isLike)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    defer {
                        self.toggleLikeState.send(index)
                    }
                    self.comments[index].isLike.toggle()
                    self.comments[index].likeCount += self.comments[index].isLike ? 1 : -1
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
        
    }
    
    public func toggleDislikeState(at index: Int) {
        patchCommentDislikeUseCase
            .execute(commentId: comments[index].id, isDislike: !comments[index].isDislike)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    defer {
                        self.toggleDislikeState.send(index)
                    }
                    self.comments[index].isDislike.toggle()
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    public func modify(at index: Int, content: String) {
        
    }
    
    public func delete(at index: Int) {
        
    }
    
    public func report(at index: Int) {
        
    }
}
