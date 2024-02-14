//
//  SideBTopicDetailView.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeature

final class SideBTopicDetailView: BaseView {
    
    private let scrollView: UIScrollView = UIScrollView()
    let topicCell: TopicDetailCollectionViewCell = TopicDetailCollectionViewCell()
    
    override func hierarchy() {
        addSubviews([scrollView])
        scrollView.addSubview(topicCell)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        topicCell.snp.makeConstraints{
            $0.width.height.equalToSuperview()
        }
    }
}
