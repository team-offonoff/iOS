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
    }
}


extension SideBTopicDetailViewController: VoteDelegate, ChatBottomSheetDelegate, TopicBottomSheetDelegate {
    
    func show(_ sender: DelegateSender) {
        
    }
    
    func vote(_ option: Choice.Option, index: Int?) {
        guard let index = viewModel.detailIdx else { return }
        viewModel.vote(option, index: index)
    }
}
