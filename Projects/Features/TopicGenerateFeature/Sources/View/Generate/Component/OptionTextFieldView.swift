//
//  OptionTextFieldView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

final class OptionTextFieldView: ABTextFieldView {
    
    init(option: Choice.Option) {
        super.init(placeholder: "\(option.content.title) 선택지를 입력해주세요", insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 42), isErrorNeed: true)
        optionLabel.textColor = option.content.color.withAlphaComponent(0.2)
        optionLabel.text = option.content.title
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let optionLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.black128.font
        return label
    }()
    
    override func style() {
        super.style()
        textField.layer.masksToBounds = true
        textField.customPlaceholder(font: Pretendard.medium18.font)
    }
    
    override func hierarchy() {
        super.hierarchy()
        textField.addSubview(optionLabel)
    }
    
    override func layout() {
        super.layout()
        optionLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    override func initialize() {
        delegate = self
        super.initialize()
    }
}

extension OptionTextFieldView: ABTextFieldViewDelegate {
    func configuration(_ textFieldView: ABTextFieldView) -> ABTextFieldViewConfiguration {
        .init(
            backgroundColor: Color.subNavy2.withAlphaComponent(0.4),
            textColor: Color.white,
            font: Pretendard.medium18.font,
            countColor: Color.subPurple.withAlphaComponent(0.6),
            countFont: Pretendard.regular15.font,
            errorColor: Color.subPurple2,
            errorFont: Pretendard.semibold13.font
        )
    }
}
