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
    private let contentView: UIView = UIView()
    let topicCell: SideBTopicDetailItemCell = SideBTopicDetailItemCell()
    
    override func hierarchy() {
        addSubviews([scrollView])
        scrollView.addSubview(contentView)
        contentView.addSubview(topicCell)
    }
    
    override func layout() {
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            if Device.height < 700 {
                $0.height.equalTo(Device.height)
            }
            else {
                $0.height.equalToSuperview()
            }
        }
        topicCell.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
    }
}
