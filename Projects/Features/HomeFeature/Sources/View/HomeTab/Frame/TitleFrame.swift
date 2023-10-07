//
//  TitleFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/10/07.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

import UIKit
import ABKit

extension HomeTabView {
    
    final class TitleFrame: BaseView {
        
        private let realTimeTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "실시간 인기 토픽"
            label.setTypo(Pretendard.regular20)
            label.textColor = Color.subPurple
            return label
        }()
        
        override func hierarchy() {
            addSubviews([realTimeTitleLabel])
        }
        
        override func layout() {
            realTimeTitleLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(2)
                $0.centerX.bottom.equalToSuperview()
            }
        }
    }
}
