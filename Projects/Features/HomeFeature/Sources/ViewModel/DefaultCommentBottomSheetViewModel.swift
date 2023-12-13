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

    private let topicId: Int
    private let fetchCommentsUseCase: any FetchCommentsUseCase
    
    public init(
        topicId: Int,
        fetchCommentsUseCase: any FetchCommentsUseCase
    ) {
        self.topicId = topicId
        self.fetchCommentsUseCase = fetchCommentsUseCase
        super.init()
    }
    
    public var comments: [HomeFeatureInterface.CommentListItemViewModel] = []
    
    public var reloadData: (() -> Void)?
    public var commentsCount: String {
        ABFormat.count(comments.count) + " 개"
    }
    
    public var errorHandler: PassthroughSubject<Domain.ErrorContent, Never> = PassthroughSubject()
    
    private var pageInfo: Paging?
    
    public func viewDidLoad() {
        fetchComments()
    }
    
    private func fetchComments() {
        
        fetchCommentsUseCase
            .execute(topicId: topicId, page: pageInfo?.page ?? 0)
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess, let (pageInfo, data) = result.data {
                    //TODO: 페이징 코드 추가
                    self.pageInfo = pageInfo
                    self.comments.append(contentsOf: data.map{ .init(comment: $0) })
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
    
}
