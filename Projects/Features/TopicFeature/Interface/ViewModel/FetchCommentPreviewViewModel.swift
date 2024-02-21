//
//  FetchCommentPreviewViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/02/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency
import Domain
import Combine
import Core

public protocol FetchCommentPreviewViewModel: BaseViewModel, ErrorHandleable {
    var topics: [Topic] { get set }
    var fetchCommentPreviewUseCase: any FetchCommentPreviewUseCase { get }
    var reloadItem: PassthroughSubject<Index, Never> { get }
    func fetchCommentPreview(index: Int)
}

extension FetchCommentPreviewViewModel {
    public func fetchCommentPreview(index: Int) {
        fetchCommentPreviewUseCase.execute(topicId: topics[index].id)
            .sink{ [weak self] result in
                if result.isSuccess, let comment = result.data {
                    defer {
                        self?.reloadItem.send(index)
                    }
                    self?.topics[index].commentPreview = comment
                }
                else if let error = result.error {
                    self?.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
}
