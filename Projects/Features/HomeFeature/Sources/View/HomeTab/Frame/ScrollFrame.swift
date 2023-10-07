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

extension HomeTabView {
    
    final class ScrollFrame: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        private var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0){
            didSet {
                collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
            }
        }
        private var topics: [String] = [String](repeating: "", count: 3)
        
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
        
        override func hierarchy() {
            addSubview(collectionView)
        }
        
        override func layout() {
            collectionView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        override func initialize() {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        
        func binding(data: [String]) {
            
        }
        
        func moveNext(){
            if currentIndexPath.row + 1 >= topics.count { return }
            currentIndexPath.row += 1
        }
        
        func movePrevious(){
            if currentIndexPath.row - 1 < 0 { return }
            currentIndexPath.row -= 1
        }
        
        //MARK: CollcetionView Delegate
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            topics.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            return collectionView.dequeueReusableCell(for: indexPath, cellType: HomeTopicCollectionViewCell.self)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: Device.width, height: collectionView.frame.height)
        }
    }
}
