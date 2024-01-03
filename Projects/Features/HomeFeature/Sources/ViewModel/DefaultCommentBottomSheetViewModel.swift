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
    private let generateCommentUseCase: any GenerateCommentUseCase
    private let fetchCommentsUseCase: any FetchCommentsUseCase
    private let patchCommentUseCase: any PatchCommentUseCase
    private let patchCommentLikeUseCase: any PatchCommentLikeStateUseCase
    private let patchCommentDislikeUseCase: any PatchCommentDislikeStateUseCase
    private let deleteCommentUseCase: any DeleteCommentUseCase
    
    public init(
        topicId: Int,
        generateCommentUseCase: any GenerateCommentUseCase,
        fetchCommentsUseCase: any FetchCommentsUseCase,
        patchCommentUseCase: any PatchCommentUseCase,
        patchCommentLikeUseCase: any PatchCommentLikeStateUseCase,
        patchCommentDislikeUseCase: any PatchCommentDislikeStateUseCase,
        deleteCommentUseCase: any DeleteCommentUseCase
    ) {
        self.topicId = topicId
        self.generateCommentUseCase = generateCommentUseCase
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.patchCommentUseCase = patchCommentUseCase
        self.patchCommentLikeUseCase = patchCommentLikeUseCase
        self.patchCommentDislikeUseCase = patchCommentDislikeUseCase
        self.deleteCommentUseCase = deleteCommentUseCase
        super.init()
    }
    
    //MARK: - OUTPUT
    public var reloadData: (() -> Void)?
    public var commentsCountTitle: String { ABFormat.count(comments.count) + " 개" }
    public var comments: [CommentListItemViewModel] = []
    public let toggleLikeState: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let toggleDislikeState: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let reportItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public var generateItem: PassthroughSubject<Void, Never> = PassthroughSubject()
    public let modifyItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let deleteItem: PassthroughSubject<Index, Never> = PassthroughSubject()
    public let errorHandler: PassthroughSubject<ErrorContent, Never> = PassthroughSubject()
    
    public func isWriterItem(at index: Int) -> Bool {
        index % 2 == 0 ? true : false //comments[index].userId == userId
    }
    
    public func hasNextPage() -> Bool {
        guard let pageInfo = pageInfo else { return false }
        return !pageInfo.last
    }
}

//MARK: - INPUT
extension DefaultCommentBottomSheetViewModel {
    
    public func fetchComments() {
        fetchCommentsUseCase
            .execute(topicId: topicId, page: pageInfo?.page ?? 0)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let (pageInfo, data) = result.data {
                    self.pageInfo = pageInfo
                    self.comments.append(contentsOf: data.map{ .init($0) })
                    self.reloadData?()
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    public func fetchNextPage() {
        updatePage()
        fetchComments()
        
        func updatePage() {
            pageInfo?.page += 1
        }
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
            .execute(commentId: comments[index].id, isDislike: !comments[index].isHate)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    defer {
                        self.toggleDislikeState.send(index)
                    }
                    self.comments[index].isHate.toggle()
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    public func generateComment(content: String) {
        generateCommentUseCase
            .execute(request: .init(topicId: topicId, content: content))
            .sink{ [weak self] result in
                
                guard let self = self else { return }
                
                if result.isSuccess, let data = result.data {
                    self.comments.insert(.init(data), at: 0)
                    self.generateItem.send(())
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
    
                }
            }
            .store(in: &cancellable)
    }
    
    public func modifyComment(at index: Int, content: String) {
        patchCommentUseCase
            .execute(commentId: comments[index].id, request: .init(content: content))
            .sink{ [weak self] result in
                
                guard let self = self else { return }
                
                if result.isSuccess, let data = result.data {
                    self.comments[index] = .init(data)
                    self.modifyItem.send(index)
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
    
                }
            }
            .store(in: &cancellable)
    }
    
    
    public func delete(at index: Int) {
        deleteCommentUseCase
            .execute(commentId: comments[index].id)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    defer {
                        self.deleteItem.send(index)
                    }
                    self.comments.remove(at: index)
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
    public func report(at index: Int) {
        
    }
}
