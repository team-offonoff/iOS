//
//  SideBTopicDetailItemCell.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import TopicFeature
import TopicFeatureInterface

final class SideBTopicDetailItemCell: TopicDetailCollectionViewCell {
    
    override func layout() {
        
        etcGroup.titleLabel.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
        }
        
        topicGroup.titleLabel.snp.makeConstraints{
            $0.top.equalTo(etcGroup.titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(102)
        }
        
        choiceGroup.swipeableView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
        }
        
        choiceStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.center.equalToSuperview()
        }
        
        choiceGroup.aChoiceView.snp.makeConstraints{
            $0.width.equalTo(choiceGroup.bChoiceView)
        }
        
        choiceGroup.completeView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.titleLabel.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        topicGroup.timer.snp.makeConstraints{
            $0.top.equalTo(choiceGroup.swipeableView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        choiceGroup.slideExplainView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.timer.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        profileStackView.snp.makeConstraints{
            $0.top.equalTo(choiceGroup.slideExplainView.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(20)
        }
        
        etcGroup.etcButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(profileStackView)
        }
        
        chat.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    override func binding(data: TopicDetailItemViewModel) {
        super.binding(data: data)
        etcGroup.titleLabel.text = data.keyword
    }
}
