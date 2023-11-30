//
//  ScrollFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/10/07.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

import UIKit
import ABKit
import Domain
import FeatureDependency

extension HomeTabView {
    
    final class ScrollFrame: BaseView {
        
        let collectionView: UICollectionView = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.register(cellType: HomeTopicCollectionViewCell.self)
            collectionView.backgroundColor = .clear
            collectionView.isScrollEnabled = false
            return collectionView
        }()
        
        let buttonFrame: ButtonFrame = ButtonFrame()
        
        override func hierarchy() {
            addSubviews([collectionView, buttonFrame])
        }
        
        override func layout() {
            collectionView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            buttonFrame.snp.makeConstraints{
                $0.top.equalToSuperview().offset(63)
                $0.leading.trailing.equalToSuperview()
            }
        }
        
        func setDelegate(to delegate: UIViewController) {
            collectionView.delegate = delegate as? UICollectionViewDelegate
            collectionView.dataSource = delegate as? UICollectionViewDataSource
        }
        
        func reloadTopics(){
            collectionView.reloadData()
        }
        
        func move(to indexPath: IndexPath) {
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}
