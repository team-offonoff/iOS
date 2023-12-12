//
//  CommentRepository.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol CommentRepository: Repository {
    func generateComment(request: GenerateCommentUseCaseRequestValue) -> NetworkResultPublisher<CommentEntity?>
    func fetchComments(topicId: Int, page: Int) -> NetworkResultPublisher<(PageEntity, [CommentEntity])?>
}
