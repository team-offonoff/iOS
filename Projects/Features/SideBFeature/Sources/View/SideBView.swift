//
//  SideBView.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class SideBView: BaseView {
    
    let keywordCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = Color.transparent
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cellType: KeywordItemCell.self)
        return collectionView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Color.transparent
        tableView.separatorStyle = .none
        tableView.registers(cellTypes: [SideBTopicItemCell.self, LoadingTableViewCell.self])
        return tableView
    }()
    
    override func hierarchy() {
        addSubviews([keywordCollectionView, tableView])
    }
    
    override func layout() {
        keywordCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(21)
            $0.height.equalTo(32)
            $0.leading.trailing.equalToSuperview()
        }
        tableView.snp.makeConstraints{
            $0.top.equalTo(keywordCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
