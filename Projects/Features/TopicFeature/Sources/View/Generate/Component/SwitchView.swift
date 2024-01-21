//
//  SwitchView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/21.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class SwitchView: BaseStackView {
    
    var isEnabled: Bool = false{
        didSet {
            let color = isEnabled ? Color.subPurple : Color.subPurple.withAlphaComponent(0.3)
            imageView.image = imageView.image?.withTintColor(color)
            explainLabel.textColor = color
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: Image.topicGenerateSwitch)
        return imageView
    }()
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular13.font
        label.text = "AB 선택지 바꾸기"
        return label
    }()
    
    override func style() {
        axis = .horizontal
        spacing = 6
        alignment = .center
        isUserInteractionEnabled = true
    }
    
    override func hierarchy() {
        addArrangedSubviews([imageView, explainLabel])
    }
}
