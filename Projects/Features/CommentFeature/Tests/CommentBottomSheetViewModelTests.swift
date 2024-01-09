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
import Core

final class CommentBottomSheetViewModelTests: XCTestCase {

    private var commentBottomSheetViewModel: CommentBottomSheetViewModel!
    private let fetchCommentsUseCase: MockFetchCommentsUseCase = MockFetchCommentsUseCase()
    private let patchLikeUseCase: MockPatchCommentLikeStateUseCase = MockPatchCommentLikeStateUseCase()
    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private var cancellable: Set<AnyCancellable> = []
    
    
    override func setUp() {
        
        setDefaultComments()
        setDefaultPaging()
        
        self.commentBottomSheetViewModel = DefaultCommentBottomSheetViewModel(
            topicId: 0,
            choices: mockTextChoices,
            generateCommentUseCase: DefaultGenerateCommentUseCase(repository: commentRepository),
            fetchCommentsUseCase: self.fetchCommentsUseCase,
            patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
            patchCommentLikeUseCase: self.patchLikeUseCase,
            patchCommentDislikeUseCase: DefaultPatchCommentDislikeStateUseCase(repository: commentRepository),
            deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
        )
        
        func setDefaultPaging() {
            fetchCommentsUseCase.paging = Paging(
                page: 0, size: fetchCommentsUseCase.comments.count, isEmpty: false, last: false
            )
        }
        
        func setDefaultComments() {
            fetchCommentsUseCase.comments = [
                .init(commentId: 0, topicId: 0, writer: .init(id: 0, nickname: "A", profileImageURl: nil), content: "작성자 댓글", likeCount: 0, hateCount: 0, isLike: false, isHate: false, createdAt: UTCTime.current),
                .init(commentId: 1, topicId: 0, writer: .init(id: 1, nickname: "B", profileImageURl: nil), content: "댓글1", likeCount: 0, hateCount: 0, isLike: false, isHate: false, createdAt: UTCTime.current)
            ]
        }
    }
    
    func test_when_댓글_조회_성공_then_데이터_재로드() {
        
        let expectation = expectation(description: "댓글 조회 성공 이후, reloadData가 실행되는지 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        
        guard var sut = commentBottomSheetViewModel else { return }
        sut.reloadData = {
            //then
            defer {
                expectation.fulfill()
            }
            XCTAssertTrue(sut.comments.count > 0)
            XCTAssertEqual(sut.comments.count, self.fetchCommentsUseCase.comments.count)
            XCTAssertEqual(sut.currentPage, 0)
        }
        
        //when
        sut.fetchComments()
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_다음_페이지가_존재하는_경우_새로운_페이지_요청_성공_then_페이지와_댓글_데이터_변화() {
        
        let expectation = expectation(description: "마지막 페이지가 아닌 경우, 조건 검사 후 다음 페이지 요청하며 페이지 수와 댓글 개수 증가 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        
        guard var sut = commentBottomSheetViewModel else { return }
        
        //첫 번째 페이지 요청은 무시한다
        var requestNextPage = false
        sut.reloadData = {
            if requestNextPage {
                //then
                defer {
                    expectation.fulfill()
                }
                XCTAssertTrue(sut.comments.count > 0)
                XCTAssertEqual(sut.comments.count, self.fetchCommentsUseCase.comments.count*2)
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
    
    func test_when_댓글_좋아요_성공_then_댓글_데이터_변화_확인() {
        //given
        patchLikeUseCase.mockType = .success
        guard let sut = commentBottomSheetViewModel else { return }
    }
    
    func test_when_댓글_좋아요_취소_성공_then_댓글_데이터_변화_확인() {
        
    }
    
    func test_when_댓글_싫어요_성공_then_댓글_데이터_변화_확인() {
        
    }
    
    func test_when_댓글_싫어요_취소_성공_then_댓글_데이터_변화_확인() {
        
    }
    
    func test_when_댓글_생성_성공_then_댓글_0번째_인덱스_추가_확인() {
        
    }
    
    func test_when_댓글_수정_성공_then_댓글_데이터_변화_확인() {
        
    }
    
    func test_when_댓글_삭제_성공_then_댓글_데이터_변화_확인() {
        
    }
}
