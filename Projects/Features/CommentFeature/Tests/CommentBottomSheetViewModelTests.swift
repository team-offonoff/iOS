//
//  CommentBottomSheetViewModelTests.swift
//  CommentFeatureTests
//
//  Created by 박소윤 on 2024/01/09.
//  Copyright © 2024 AB. All rights reserved.
//

import XCTest
import Combine
import CommentFeature
import CommentFeatureInterface
import Domain
import Data

final class CommentBottomSheetViewModelTests: XCTestCase {

    private var commentBottomSheetViewModel: CommentBottomSheetViewModel!
    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private var cancellable: Set<AnyCancellable> = []
    
    override func setUp() {
        self.commentBottomSheetViewModel = DefaultCommentBottomSheetViewModel(
            topicId: 0,
            choices: mockTextChoices,
            generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
            fetchCommentsUseCase: MockFetchCommentsUseCase(.success),
            patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
            patchCommentLikeUseCase: DefaultPatchCommentLikeStateUseCase(repository: commentRepository),
            patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
            deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
        )
    }
    
    func test_when_댓글_조회_성공_then_데이터_재로드() {
        
        let expectation = expectation(description: "댓글 조회 성공 이후, reloadData가 실행되는지 확인")
        
        //given
        guard var sut = commentBottomSheetViewModel else  { return }
        sut.reloadData = {
            //then
            defer {
                expectation.fulfill()
            }
            XCTAssertTrue(sut.comments.count > 0)
            XCTAssertEqual(sut.currentPage, 0)
        }
        
        //when
        sut.fetchComments()
        
        waitForExpectations(timeout: 10)
    }
}
