//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import ABKit
import UIKit
import Domain
import FeatureDependency

class HomeTopicCollectionViewCell: BaseCollectionViewCell, Binding{
    
    private let informationFrame: InformationFrame = InformationFrame()
    private let selectionFrame: SelectionFrame = SelectionFrame()
    let userFrame: UserFrame = UserFrame()
    
    override func hierarchy() {
        baseView.addSubviews([informationFrame, selectionFrame, userFrame])
    }
    
    override func layout() {
        informationFrame.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2)
            $0.leading.trailing.equalToSuperview()
        }
        selectionFrame.snp.makeConstraints{
            $0.top.equalTo(informationFrame.snp.bottom).offset(37)
            $0.leading.trailing.equalToSuperview()
        }
        userFrame.snp.makeConstraints{
            $0.top.equalTo(selectionFrame.snp.bottom).offset(49)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func binding(data: Topic) {
        informationFrame.titleLabel.text = data.title
        selectionFrame.aFrame.contentLabel.text = data.choices.first(where: { $0.option == .A })?.content.text
        selectionFrame.bFrame.contentLabel.text = data.choices.first(where: { $0.option == .B })?.content.text
    }
    
    func binding(timer: TimerInfo) {
        informationFrame.timer.binding(data: timer)
    }
}
