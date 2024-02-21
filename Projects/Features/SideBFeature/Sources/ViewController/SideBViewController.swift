//
//  SideBViewController.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import SideBFeatureInterface
import FeatureDependency
import Domain

final class SideBViewController: BaseViewController<SideTabHeaderView, SideBView, DefaultSideBCoordinator> {
    
    init(viewModel: any SideBViewModel) {
        self.viewModel = viewModel
        super.init(headerView: SideTabHeaderView(icon: Image.sideBHeader), mainView: SideBView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any SideBViewModel
    
    override func viewDidAppear(_ animated: Bool) {
        // 처음 뷰가 보여질 때, 0번째 인덱스 select 상태로 만들기
        if let keywordIdx = viewModel.fetchTopicQuery.keywordIdx?.value, mainView.keywordCollectionView.indexPathsForSelectedItems?.isEmpty == true {
            mainView.keywordCollectionView.selectItem(at: .init(row: keywordIdx), animated: false, scrollPosition: .left)
        }
    }
    
    override func initialize() {

        delegate()
        
        func delegate() {
            
            mainView.tableView.delegate = self
            mainView.tableView.dataSource = self
            
            mainView.keywordCollectionView.delegate = self
            mainView.keywordCollectionView.dataSource = self
        }
        
        headerView?.progressPublisher = viewModel.fetchTopicQuery.status
    }
    
    override func bind() {
        
        reloadTopics()
        bindVoteSuccess()

        func reloadTopics() {
            viewModel.reloadTopics = {
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            }
        }

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
        
        func bindVoteSuccess() {
            viewModel.successVote
                .receive(on: DispatchQueue.main)
                .sink{ [weak self] index, choice in
                    guard let self = self else { return }
                    self.mainView.tableView.reloadRows(at: [.init(row: index)], with: .none)
                }
                .store(in: &cancellables)
        }
    }
    
    //MARK: 페이징
    
    private var isLoading: Bool = false
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if viewModel.topics.isEmpty {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if !isLoading && viewModel.hasNextPage() {
                beginPaging()
            }
        }
        
        func startLoading() {
            isLoading = true
        }
        
        func beginPaging(){
            
            startLoading()
            
            DispatchQueue.main.async {
                self.mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.fetchNextPage()
            }
        }
    }
    
    private func stopLoading() {
        isLoading = false
    }
    
}

extension SideBViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.topics.count
        }
        else if section == 1 && isLoading && viewModel.hasNextPage() {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:     return topicCell()
        case 1:     return loadingCell()
        default:    fatalError()
        }
        
        func topicCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SideBTopicItemCell.self)
//            cell.fill(topic: viewModel.topics[indexPath.row])
            return cell
        }
        
        func loadingCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: LoadingTableViewCell.self)
            cell.startLoading()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.startTopicDetail(index: indexPath.row)
    }
}

extension SideBViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: KeywordItemCell.self)
        cell.isCellSelected = viewModel.fetchTopicQuery.keywordIdx?.value == indexPath.row
        cell.fill(title: viewModel.keywords[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        KeywordItemCell.itemSize(title: viewModel.keywords[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            viewModel.fetchTopicQuery.keywordIdx?.send(indexPath.row)
        }
        let cell = collectionView.cellForItem(at: indexPath, cellType: KeywordItemCell.self)
        cell?.isCellSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath, cellType: KeywordItemCell.self)
        cell?.isCellSelected = false
    }
}
