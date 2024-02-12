//
//  TopicSideChangeButton.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/01.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class TopicSideChangeButton: UIButton {
    
    init(side: Topic.Side) {
        self.side = side
        super.init(frame: .zero)
        style()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let side: Topic.Side
    
    private func style() {
        
        let sideTitle = "\(side.content.title) 사이드"
        let explainTitle = " 로 변경하기"
        let attributedString = NSMutableAttributedString(string: sideTitle+explainTitle)
        attributedString.addAttribute(.font, value: Pretendard.semibold14.font, range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: side.content.color.withAlphaComponent(0.8), range: NSRange(location: 0, length: sideTitle.count))
        attributedString.addAttribute(.foregroundColor, value: Color.white, range: NSRange(location: sideTitle.count, length: explainTitle.count))
        
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20)
        configuration.background.backgroundColor = side.content.color.withAlphaComponent(0.4)
        configuration.attributedTitle = AttributedString(attributedString)
        self.configuration = configuration
    }
}
