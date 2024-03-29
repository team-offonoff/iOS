//
//  HomeTabViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import FeatureDependency
import TopicFeature
import HomeFeatureInterface
import Core
import Domain

final class HomeTabViewController: BaseViewController<HeaderView, HomeTabView, DefaultHomeCoordinator>{

    init(viewModel: any HomeTabViewModel){
        self.viewModel = viewModel
        super.init(
            headerView: HeaderView(
                icon: Image.alarm,
                selectedIcon: Image.alarmOn),
            mainView: HomeTabView()
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var currentTopicCell: TopicDetailCollectionViewCell? //timer ui 업데이트 편의를 위한 셀 저장 프로퍼티
    
    private let viewModel: any HomeTabViewModel
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.topics.count > 0 {
            viewModel.startTimer()
        }
    }
    
    /* 댓글 바텀시트 기준 Y 값 구하기
    private func standardOfCommentBottomSheet() -> CGFloat {
        view.convert((currentTopicCell?.standardOfCommentBottomSheetNormalState().frame)!, from: currentTopicCell).maxY
    }
     */
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopTimer()
    }
    
    override func initialize() {
        
        viewModel.fetchTopics()
        setDelegate()
        moveAlarm()
        addButtonFrameTarget()
        previousVisibility()
        
        func setDelegate(){
            mainView.scrollFrame.setDelegate(to: self)
        }
        
        func moveAlarm() {
            headerView?.rightItem.tapPublisher
                .sink{ [weak self] _ in
                    self?.coordinator?.startAlarm()
                }
                .store(in: &cancellables)
        }
        
        func addButtonFrameTarget(){
            mainView.scrollFrame.buttonFrame.previousButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.viewModel.movePreviousTopic()
                }.store(in: &cancellables)
            
            mainView.scrollFrame.buttonFrame.nextButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.viewModel.moveNextTopic()
                }.store(in: &cancellables)
        }
        
        func previousVisibility() {
            mainView.scrollFrame.buttonFrame.previousButton.isHidden = true
            mainView.scrollFrame.buttonFrame.nextButton.isHidden = true
        }
    }
    
    override func bind() {
        
        bindError()
        bindReloadTopics()
        bindMoveTopic()
        bindTimer()
        bindVoteSuccess()
        bindImageExpandNotification()
        bindFailVote()
        bindRevoteNotification()
        bindCommentReload()
        
        func bindError() {
            viewModel.errorHandler
                .receive(on: DispatchQueue.main)
                .sink{ error in
                    ToastMessage.shared.register(message: error.message)
                }
                .store(in: &cancellables)
        }
        
        func bindReloadTopics(){
            viewModel.reloadTopics = {
                DispatchQueue.main.async {
                    self.mainView.scrollFrame.reloadTopics()
                    self.setMoveButtonVisibility()
                }
            }
        }
        
        func bindMoveTopic(){
            viewModel.willMovePage
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] indexPath in
                    self?.mainView.scrollFrame.move(to: indexPath)
                    setMoveButtonVisibility()
                }
                .store(in: &cancellables)
            
            func setMoveButtonVisibility(){
                mainView.scrollFrame.buttonFrame.previousButton.isHidden = !viewModel.canMovePrevious
                mainView.scrollFrame.buttonFrame.nextButton.isHidden = !viewModel.canMoveNext
            }
        }
        
        func bindVoteSuccess() {
            viewModel.successVote
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] index, choice in
                    guard let self = self else { return }
                    self.currentTopicCell?.select(choice: self.viewModel.currentTopic.choices[choice]!)
                }
                .store(in: &cancellables)
        }
        
        func bindTimer(){
            viewModel.timerSubject
                .receive(on: RunLoop.main)
                .sink{ [weak self] time in
                    self?.currentTopicCell?.binding(timer: time)
                }
                .store(in: &cancellables)
        }
        
        func bindImageExpandNotification() {
            //Image Choice Content에서 notification post
            NotificationCenter.default
                .publisher(for: Notification.Name(Topic.Action.expandImage.identifier), object: currentTopicCell)
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] receive in
                    if let choice = receive.userInfo?[Choice.identifier] as? Choice {
                        self?.coordinator?.startImagePopUp(choice: choice)
                    }
                }
                .store(in: &cancellables)
        }
        
        func bindFailVote() {
            viewModel.failVote
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] index in
                    guard let self = self else { return }
                    self.currentTopicCell?.failVote()
                }
                .store(in: &cancellables)
        }
        
        func bindRevoteNotification() {
            NotificationCenter.default.publisher(for: Notification.Name(Topic.Action.revote.identifier), object: viewModel)
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] _ in
                    guard let self = self else { return }
                    // 1. 토스트 메시지 보여주기
                    ToastMessage.shared.register(message: "다시 선택하면, 해당 토픽에 작성한 댓글이 삭제돼요")
                    // 2. 선택지 다시 보여주기
                    self.currentTopicCell?.clearVote()
                    
                }
                .store(in: &cancellables)
        }
        
        func bindCommentReload() {
            viewModel.reloadItem
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] index in
                    guard let self = self else { return }
                    if index == self.viewModel.topicIndex {
                        self.currentTopicCell?.binding(data: .init(topic: self.viewModel.topics[index]), comment: self.viewModel.topics[index].commentPreview)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func setMoveButtonVisibility(){
        mainView.scrollFrame.buttonFrame.previousButton.isHidden = !viewModel.canMovePrevious
        mainView.scrollFrame.buttonFrame.nextButton.isHidden = !viewModel.canMoveNext
    }
}

//MARK: CollcetionView Delegate
extension HomeTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.topics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TopicDetailCollectionViewCell.self)
        cell.delegate = self
        cell.binding(data: .init(topic: viewModel.topics[indexPath.row]), comment: viewModel.topics[indexPath.row].commentPreview)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Device.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentTopicCell = cell as? TopicDetailCollectionViewCell
        //댓글 프리뷰가 없는 경우, API 요청하기
        if viewModel.topics[indexPath.row].commentCount > 0 && viewModel.topics[indexPath.row].commentPreview == nil {
            viewModel.fetchCommentPreview(index: indexPath.row)
        }
    }
}

extension HomeTabViewController: ChatBottomSheetDelegate, TopicBottomSheetDelegate {
    
    func show(_ sender: DelegateSender) {
        switch sender.identifier {
        case Topic.Action.showBottomSheet.identifier:
            coordinator?.startTopicBottomSheet()
        case Comment.Action.showBottomSheet.identifier:
            coordinator?
                .startCommentBottomSheet(
                    topicId: viewModel.currentTopic.id,
                    choices: viewModel.currentTopic.choices
                )
        default:
            return
        }
    }
}

extension HomeTabViewController: VoteDelegate {
    func vote(_ option: Choice.Option, index: Int?) {
        print(option)
        guard let index = index else { return }
        if viewModel.currentTopic.isVoted {
            viewModel.revote(option, index: index)
        }
        else {
            viewModel.vote(option, index: index)
        }
    }
}
