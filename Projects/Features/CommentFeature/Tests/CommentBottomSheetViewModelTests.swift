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
    private let topicId = 0
    private let generateCommentUseCase: MockGenerateCommentUseCase = MockGenerateCommentUseCase()
    private let fetchCommentsUseCase: MockFetchCommentsUseCase = MockFetchCommentsUseCase()
    private let patchLikeUseCase: MockPatchCommentLikeStateUseCase = MockPatchCommentLikeStateUseCase()
    private let patchDislikeUseCase: MockPatchCommentDislikeStateUseCase = MockPatchCommentDislikeStateUseCase()
    private let commentRepository: CommentRepository = DefaultCommentRepository()
    private var cancellable: Set<AnyCancellable> = []
    
    
    override func setUp() {
        
        setDefaultComments()
        setDefaultPaging()
        
        self.commentBottomSheetViewModel = DefaultCommentBottomSheetViewModel(
            topicId: self.topicId,
            choices: mockTextChoices,
            generateCommentUseCase: generateCommentUseCase,
            fetchCommentsUseCase: self.fetchCommentsUseCase,
            patchCommentUseCase: DefaultPatchCommentUseCase(repository: commentRepository),
            patchCommentLikeUseCase: self.patchLikeUseCase,
            patchCommentDislikeUseCase: self.patchDislikeUseCase,
            deleteCommentUseCase: DefaultDeleteCommentUseCase(repository: commentRepository)
        )
        
        func setDefaultPaging() {
            fetchCommentsUseCase.paging = Paging(
                page: 0, size: fetchCommentsUseCase.comments.count, isEmpty: false, last: false
            )
        }
        
        func setDefaultComments() {
            fetchCommentsUseCase.comments = [
                .init(commentId: 0, topicId: 0, writer: .init(id: 0, nickname: "A", profileImageURl: nil), votedOption: nil, content: "작성자 댓글", likeCount: 0, hateCount: 0, isLike: false, isHate: false, createdAt: UTCTime.current),
                .init(commentId: 1, topicId: 0, writer: .init(id: 1, nickname: "B", profileImageURl: nil), votedOption: .B, content: "댓글1", likeCount: 1, hateCount: 1, isLike: true, isHate: true, createdAt: UTCTime.current)
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
        
        let expectation = expectation(description: "댓글 좋아요 성공한 경우, publisher가 방출되며 댓글 데이터가 정상적으로 변경되었는지 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        patchLikeUseCase.mockType = .success
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        sut.toggleLikeState
            .sink{ index in
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual(index, 0)
                XCTAssertTrue(sut.comments[index].isLike)
                XCTAssertEqual(sut.comments[index].likeCount, 1)
            }
            .store(in: &cancellable)
        
        //when
        sut.toggleLikeState(at: 0)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_댓글_좋아요_취소_성공_then_댓글_데이터_변화_확인() {
        
        let expectation = expectation(description: "댓글 좋아요 취소 성공한 경우, publisher가 방출되며 댓글 데이터가 정상적으로 변경되었는지 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        patchLikeUseCase.mockType = .success
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        sut.toggleLikeState
            .sink{ index in
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual(index, 1)
                XCTAssertTrue(!sut.comments[index].isLike)
                XCTAssertEqual(sut.comments[index].likeCount, 0)
            }
            .store(in: &cancellable)
        
        //when
        sut.toggleLikeState(at: 1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_댓글_싫어요_성공_then_댓글_데이터_변화_확인() {
        
        let expectation = expectation(description: "댓글 싫어요 성공한 경우, publisher가 방출되며 댓글 데이터가 정상적으로 변경되었는지 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        patchDislikeUseCase.mockType = .success
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        sut.toggleDislikeState
            .sink{ index in
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual(index, 0)
                XCTAssertTrue(sut.comments[index].isHate)
            }
            .store(in: &cancellable)
        
        //when
        sut.toggleDislikeState(at: 0)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_댓글_싫어요_취소_성공_then_댓글_데이터_변화_확인() {
        
        let expectation = expectation(description: "댓글 싫어요 취소 성공한 경우, publisher가 방출되며 댓글 데이터가 정상적으로 변경되었는지 확인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        patchDislikeUseCase.mockType = .success
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        sut.toggleDislikeState
            .sink{ index in
                defer {
                    expectation.fulfill()
                }
                XCTAssertEqual(index, 1)
                XCTAssertTrue(!sut.comments[index].isHate)
            }
            .store(in: &cancellable)
        
        //when
        sut.toggleDislikeState(at: 1)
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_유저가_댓글_작성자인_경우_then_선택지_작성자로_표시() {
         
        //given
        fetchCommentsUseCase.mockType = .success
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        
        //when
        UserManager.shared.memberId = 0
        
        //then
        XCTAssertEqual(sut.comments[0].selectedOption.option, nil)
        XCTAssertEqual(sut.comments[0].selectedOption.content, "작성자")
    }
    
    func test_when_유저가_댓글_작성자가_아닌_경우_then_선택지_데이터_확인() {
        
        //given
        fetchCommentsUseCase.mockType = .success
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        
        //when
        UserManager.shared.memberId = 0
        
        //then
        XCTAssertTrue(sut.comments[1].selectedOption.option != nil)
        XCTAssertTrue(sut.comments[1].selectedOption.content.starts(with: "B."))
    }
    
    func test_when_댓글_생성_성공_then_댓글_0번째_인덱스_추가_확인() {
        
        let expectation = expectation(description: "댓글 작성 성공한 경우, 데이터 변화 학인")
        
        //given
        fetchCommentsUseCase.mockType = .success
        
        generateCommentUseCase.mockType = .success
        generateCommentUseCase.comment = .init(
            commentId: 3,
            topicId: topicId,
            writer: .init(id: 3, nickname: "C", profileImageURl: nil),
            votedOption: .A,
            content: "새로운 댓글",
            likeCount: 0,
            hateCount: 0,
            isLike: false,
            isHate: false,
            createdAt: UTCTime.current
        )
        
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        sut.generateItem
            .sink{ _ in
                defer {
                    expectation.fulfill()
                }
                //then
                XCTAssertEqual(sut.comments.count, self.fetchCommentsUseCase.comments.count+1)
                XCTAssertEqual(sut.comments[0].id, 3)
            }
            .store(in: &cancellable)
        
        //when
        sut.generateComment(content: "새로운 댓글")
        
        waitForExpectations(timeout: 10)
    }
    
    func test_when_댓글_수정_성공_then_댓글_데이터_변화_확인() {
        
        //given
        guard let sut = commentBottomSheetViewModel else { return }
        sut.fetchComments()
        
        
    }
    
    func test_when_댓글_삭제_성공_then_댓글_데이터_변화_확인() {
        
    }
}
