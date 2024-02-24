//
//  PageNumberIndicator.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class PageNumberIndicator: BaseStackView {
    
    var cells: [PageCell] {
        subviews.compactMap { $0 as? PageCell }
    }
    
    override func style() {
        spacing = 0
        axis = .horizontal
        alignment = .center
    }
    
    override func hierarchy() {
        let line = SeparatorLine(color: Color.subNavy2, height: 2)
        line.snp.makeConstraints{
            $0.width.equalTo(13)
        }
        addArrangedSubviews([PageCell(number: 1), line, PageCell(number: 2)])
    }
}

extension PageNumberIndicator {
    
    final class PageCell: UILabel {
        
        init(number: Int) {
            super.init(frame: .zero)
            text = String(number)
            textColor = Color.subNavy2
            font = Pretendard.medium16.font
            textAlignment = .center
            backgroundColor = Color.subNavy
            layer.borderWidth = 2
            layer.borderColor = Color.subNavy2.cgColor
            layer.cornerRadius = 34/2
            layer.masksToBounds = true
            self.snp.makeConstraints{
                $0.width.height.equalTo(34)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func highlight() {
            textColor = Color.subPurple
            layer.borderColor = Color.subPurple.cgColor
        }
    }
}
