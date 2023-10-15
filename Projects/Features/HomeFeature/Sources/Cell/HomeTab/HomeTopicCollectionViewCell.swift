//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import ABKit
import UIKit

class HomeTopicCollectionViewCell: BaseCollectionViewCell{
    
    let topicInformationFrame: TopicInformationFrame = TopicInformationFrame()
    let selectionFrame: SelectionFrame = SelectionFrame()
    let userFrame: UserFrame = UserFrame()
    
    override func hierarchy() {
        baseView.addSubviews([topicInformationFrame, selectionFrame, userFrame])
    }
    
    override func layout() {
        topicInformationFrame.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        selectionFrame.snp.makeConstraints{
            $0.top.equalTo(topicInformationFrame.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview()
        }
        userFrame.snp.makeConstraints{
            $0.top.equalTo(selectionFrame.snp.bottom).offset(49)
            $0.leading.trailing.equalToSuperview()
        }
    }
}