//
//  TopicGenerateViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeatureInterface
import FeatureDependency

final class TopicGenerateViewController: BaseViewController<BaseHeaderView, TopicGenerateView, DefaultTopicGenerateCoordinator> {

    init(viewModel: any TopicGenerateViewModel) {
        self.viewModel = viewModel
        super.init(headerView: TopicGenerateHeaderView(), mainView: TopicGenerateView())
    }
    
    private let viewModel: any TopicGenerateViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension TopicGenerateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:     return inputTableViewCell()
        case 1:     return contentInputTableViewCell()
        default:    fatalError()
        }
        
        func inputTableViewCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TopicInputTableViewCell.self)
            cell.title.contentView.limitCount = 6
            cell.keyword.contentView.limitCount = 6
            cell.recommendKeyword.collectionView.delegate = self
            cell.recommendKeyword.collectionView.dataSource = self
            return cell
        }
        
        func contentInputTableViewCell() -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TopicContentInputTableViewCell.self)
            return cell
        }
    }

}

extension TopicGenerateViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recommendKeywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RecommendKeywordCollectionViewCell.self)
        cell.fill(viewModel.recommendKeywords[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        RecommendKeywordCollectionViewCell.size(viewModel.recommendKeywords[indexPath.row])
    }
    
}
