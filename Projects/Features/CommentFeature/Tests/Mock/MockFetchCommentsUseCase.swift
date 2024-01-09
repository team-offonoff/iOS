//
//  MockFetchCommentsUseCase.swift
//  CommentFeatureTests
//
//  Created by 박소윤 on 2024/01/09.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Combine
import Domain
import Core

final class MockFetchCommentsUseCase: FetchCommentsUseCase {
    
    init(_ type: MOCKType){
        self.mockType = type
    }
    
    init(repository: CommentRepository) {
        fatalError()
    }
    
    private let mockType: MOCKType
    
    //MARK: Output
    
    var paging: Paging!
    let comments: [Comment] = [
        .init(commentId: 0, topicId: 0, writer: .init(id: 0, nickname: "A", profileImageURl: nil), content: "작성자 댓글", likeCount: 0, hateCount: 0, isLike: false, isHate: false, createdAt: UTCTime.current),
        .init(commentId: 1, topicId: 0, writer: .init(id: 1, nickname: "B", profileImageURl: nil), content: "댓글1", likeCount: 0, hateCount: 0, isLike: false, isHate: false, createdAt: UTCTime.current)
    ]
    
    func execute(topicId: Int, page: Int) -> NetworkResultPublisher<(Paging, [Comment])?> {
        switch mockType {
        case .success:
            return AnyPublisher(Just((
                isSuccess: true,
                data: Optional((paging, comments)),
                error: Optional<ErrorContent>(nil))
            ))
            
        case .failure:
            return AnyPublisher(Just((
                isSuccess: false,
                data: Optional<(Paging, [Comment])>(nil),
                error: Optional<ErrorContent>(ErrorContent(code: .emptyAuthorization, message: "통신 에러"))
            )))
        }
    }
}
