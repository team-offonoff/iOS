//
//  TopicBottomSheetViewModel.swift
//  TopicFeatureInterface
//
//  Created by 박소윤 on 2024/01/10.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine
import Core
import FeatureDependency

public protocol TopicBottomSheetViewModel: BaseViewModel {
    var topics: [Topic] { get }
    var topicIndex: Int? { get set }
    var successTopicAction: PassthroughSubject<Topic.Action, Never> { get }
    var canRevote: Bool { get }
    var hideTopicUseCase: any HideTopicUseCase { get }
    func hideTopic(index: Int)
    func reportTopic(index: Int)
}

extension TopicBottomSheetViewModel {
    public func hideTopic(index: Int) {
        guard let userId = UserManager.shared.memberId else { return }
        hideTopicUseCase
            .execute(
                topicId: topics[index].id,
                request: .init(memberId: userId)
            )
            .sink{ [weak self] result in
                guard let self = self else { return }
                if result.isSuccess {
                    self.successTopicAction.send(Topic.Action.hide)
                }
                else if let error = result.error {
                    self.errorHandler.send(error)
                }
            }
            .store(in: &cancellable)
    }
}
