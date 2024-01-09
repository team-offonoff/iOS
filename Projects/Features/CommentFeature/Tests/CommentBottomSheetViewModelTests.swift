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

    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private var cancellable: Set<AnyCancellable> = []
    
    func test_when_댓글_조회_성공_then_데이터_재로드() {
        
        let expectation = expectation(description: "댓글 조회 성공 이후, reloadData가 실행되는지 확인")
        
        //given
        let fetchCommentsUseCase = MockFetchCommentsUseCase(.success)
        fetchCommentsUseCase.paging = Paging(page: 0, size: fetchCommentsUseCase.comments.count, isEmpty: false, last: true)
        let sut = DefaultCommentBottomSheetViewModel(
            topicId: 0,
            choices: mockTextChoices,
            generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
            fetchCommentsUseCase: fetchCommentsUseCase,
            patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
            patchCommentLikeUseCase: DefaultPatchCommentLikeStateUseCase(repository: commentRepository),
            patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
            deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
        )
        sut.reloadData = {
            //then
            defer {
                expectation.fulfill()
            }
            XCTAssertTrue(sut.comments.count > 0)
            XCTAssertEqual(sut.comments.count, fetchCommentsUseCase.comments.count)
            XCTAssertEqual(sut.currentPage, 0)
        }
        
        //when
        sut.fetchComments()
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_다음_페이지가_존재하는_경우_새로운_페이지_요청_성공_then_페이지와_댓글_데이터_변화() {
        
        let expectation = expectation(description: "마지막 페이지가 아닌 경우, 조건 검사 후 다음 페이지 요청하며 페이지 수와 댓글 개수 증가 확인")
        
        //given
        let fetchCommentsUseCase = MockFetchCommentsUseCase(.success)
        fetchCommentsUseCase.paging = Paging(page: 0, size: fetchCommentsUseCase.comments.count, isEmpty: false, last: false)
        let sut = DefaultCommentBottomSheetViewModel(
            topicId: 0,
            choices: mockTextChoices,
            generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
            fetchCommentsUseCase: fetchCommentsUseCase,
            patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
            patchCommentLikeUseCase: DefaultPatchCommentLikeStateUseCase(repository: commentRepository),
            patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
            deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
        )
        
        //첫 번째 페이지 요청은 무시한다
        var requestNextPage = false
        sut.reloadData = {
            if requestNextPage {
                //then
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual(sut.comments.count, fetchCommentsUseCase.comments.count*2)
                XCTAssertEqual(sut.currentPage, 1)
            }
        }

        //when
        sut.fetchComments()
        if sut.hasNextPage() {
            requestNextPage = true
            fetchCommentsUseCase.paging = Paging(page: 1, size: fetchCommentsUseCase.comments.count, isEmpty: false, last: true)
            sut.fetchNextPage()
        }
        
        waitForExpectations(timeout: 10)
    }
}
