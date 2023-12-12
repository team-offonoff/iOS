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
    
    public var errorHandler: PassthroughSubject<Domain.ErrorContent, Never> = PassthroughSubject()
    
    private var pageInfo: PageEntity?
    
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
                    self.comments.append(contentsOf: mapItemViewModel(data))
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
        
        func mapItemViewModel(_ comments: [CommentEntity]) -> [CommentListItemViewModel] {
            comments
                .map{
                    .init(
                        profileImageUrl: $0.writer.profileImageURl,
                        nickname: $0.writer.nickname,
                        date: "",
                        choice: "",
                        content: $0.content,
                        likeCount: $0.likes
                    )
                }
        }
    }
    
}
