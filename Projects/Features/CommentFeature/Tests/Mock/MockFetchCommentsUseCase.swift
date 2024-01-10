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

final class MockFetchCommentsUseCase: FetchCommentsUseCase {
    
    init() {
        
    }
    
    init(repository: CommentRepository) {
        fatalError()
    }
    
    //MARK: Input
    
    var mockType: MOCKType!
    
    //MARK: Output
    
    var paging: Paging!
    var comments: [Comment]!
    
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
            
        default:
            fatalError()
        }
    }
}
