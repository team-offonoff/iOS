//
//  SideBTopicDetailViewController.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class SideBTopicDetailViewController: BaseViewController<NavigateHeaderView, SideBTopicDetailView, DefaultSideBCoordinator> {
    
    init(viewModel: SideBViewModel){
        self.viewModel = viewModel
        super.init(headerView: NavigateHeaderView(title: nil, icon: nil, selectedIcon: nil), mainView: SideBTopicDetailView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any SideBViewModel
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopTimer()
    }
    
    override func initialize() {
        mainView.topicCell.delegate = self
        mainView.topicCell.binding(data: .init(topic: viewModel.topics[0].topic))
    }
    
    override func bind() {
        
        bindTimer()
        bindVoteSuccess()
        bindFailVote()
        addRevoteNotification()
        
        func bindTimer(){
            viewModel.timerSubject
                .receive(on: RunLoop.main)
                .sink{ [weak self] time in
                    self?.mainView.topicCell.binding(timer: time)
                }
                .store(in: &cancellables)
        }
        
        func bindVoteSuccess() {
            viewModel.successVote
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] index, choice in
                    guard let self = self else { return }
                    self.mainView.topicCell.select(choice: self.viewModel.topics[index].choices[choice]!)
                }
                .store(in: &cancellables)
        }
        
        func bindFailVote() {
            viewModel.failVote
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] _ in
                    guard let self = self else { return }
                    self.mainView.topicCell.failVote()
                }
                .store(in: &cancellables)
        }
        
        func addRevoteNotification() {
            NotificationCenter.default.publisher(for: Notification.Name(Topic.Action.revote.identifier), object: viewModel)
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] _ in
                    guard let self = self else { return }
                    // 1. 토스트 메시지 보여주기
                    ToastMessage.shared.register(message: "다시 선택하면, 해당 토픽에 작성한 댓글이 삭제돼요")
                    // 2. 선택지 다시 보여주기
                    self.mainView.topicCell.clearVote()
                    
                }
                .store(in: &cancellables)
        }
    }
}

extension SideBTopicDetailViewController: VoteDelegate, ChatBottomSheetDelegate, TopicBottomSheetDelegate {
    
    func show(_ sender: DelegateSender) {
        guard let index = viewModel.topicIndex else { return }
        switch sender.identifier {
        case Topic.Action.showBottomSheet.identifier:
            coordinator?.startTopicBottomSheet()
        case Comment.Action.showBottomSheet.identifier:
            coordinator?
                .startCommentBottomSheet(
                    topicId: viewModel.topics[index].id,
                    choices: viewModel.topics[index].choices
                )
        default:
            return
        }
    }
    
    func vote(_ option: Choice.Option, index: Int?) {
        guard let index = viewModel.topicIndex else { return }
        viewModel.vote(option, index: index)
    }
}
