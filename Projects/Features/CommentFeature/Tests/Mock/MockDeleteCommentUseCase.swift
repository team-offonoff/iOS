//
//  MockDeleteCommentUseCase.swift
//  CommentFeatureTests
//
//  Created by 박소윤 on 2024/01/09.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import Domain
import Combine

final class MockDeleteCommentUseCase: DeleteCommentUseCase {
    
    init(){
        
    }
    
    init(repository: CommentRepository) {
        fatalError()
    }
    
    var mockType: MOCKType!
    
    func execute(commentId: Int) -> NetworkResultPublisher<Any?> {
        switch mockType {
        case .success:
            return Just((
                isSuccess: true,
                data: Optional<Any>(nil),
                error: Optional<ErrorContent>(nil))
            ).eraseToAnyPublisher()
            
        case .failure:
            return Just((
                isSuccess: false,
                data: Optional<Comment>(nil),
                error: Optional<ErrorContent>(ErrorContent(code: .emptyAuthorization, message: "통신 에러"))
            )).eraseToAnyPublisher()
            
        default:
            fatalError()
        }
    }
}

