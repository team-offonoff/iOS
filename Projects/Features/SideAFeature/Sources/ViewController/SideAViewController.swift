//
//  SideAViewController.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import SideAFeatureInterface
import FeatureDependency
import Domain

final class SideAViewController: BaseViewController<SideTabHeaderView, SideAView, DefaultSideACoordinator> {
    
    init(viewModel: any SideAViewModel){
        self.viewModel = viewModel
        super.init(headerView: SideTabHeaderView(icon: Image.sideAHeader), mainView: SideAView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: any SideAViewModel
    
    override func initialize() {

        delegate()
        
        func delegate() {
            mainView.tableView.delegate = self
            mainView.tableView.dataSource = self
        }
        
        headerView?.progressPublisher = viewModel.fetchTopicQuery.status
    }
    
    override func bind() {
        
        reloadTopics()
        
        func reloadTopics() {
            viewModel.reloadTopics = {
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            }
        }
        
        viewModel.successVote
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] (index, _) in
                self?.mainView.tableView.reloadRows(at: [IndexPath(row: index)], with: .none)
            }
            .store(in: &cancellables)
        
        viewModel.errorHandler
            .receive(on: DispatchQueue.main)
            .sink{ error in
                ToastMessage.shared.register(message: error.message)
            }
            .store(in: &cancellables)
        
        NotificationCenter
            .default
            .publisher(for: Notification.Name(Comment.Action.showBottomSheet.identifier), object: mainView.tableView)
            .sink{ [weak self] object in
                guard let self = self, let index = object.userInfo?["Index"] as? Int else { return }
                self.coordinator?.startCommentBottomSheet(
                    topicId: self.viewModel.topics[index].id,
                    choices: self.viewModel.topics[index].choices
                )
            }
            .store(in: &cancellables)
        
    }
}

extension SideAViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SideATopicTableViewCell.self)
        cell.delegate = self
        cell.fill(topic: viewModel.topics[indexPath.row])
        return cell
    }
}

extension SideAViewController: VoteDelegate {
    func vote(_ option: Choice.Option, index: Int) {
        viewModel.vote(option, index: index)
    }
}
