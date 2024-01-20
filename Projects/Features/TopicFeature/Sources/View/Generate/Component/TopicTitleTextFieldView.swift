//
//  TopicTitleTextFieldView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine

final class TopicTitleTextFieldView: ABTextFieldView {
    
    init() {
        super.init(placeholder: "제목을 입력해 주세요", insets: UIEdgeInsets(top: 4, left: 0, bottom: 10, right: 40), isErrorNeed: true)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let separtorLine: SeparatorLine = SeparatorLine(color: Color.subNavy2, height: 1)
    
    override func style() {
        super.style()
        textField.customPlaceholder(color: UIColor(r: 163, g: 111, b: 243), font: Pretendard.regular20.font)
    }
    
    override func hierarchy() {
        super.hierarchy()
        textField.addSubview(separtorLine)
    }
    
    override func layout() {
        super.layout()
        separtorLine.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize() {
        delegate = self
        super.initialize()
        $state
            .sink { [weak self] state in
                switch state {
                case .error:
                    self?.separtorLine.backgroundColor = Color.subPurple2
                default:
                    self?.separtorLine.backgroundColor = Color.subNavy2
                }
            }
            .store(in: &cancellable)
    }
}

extension TopicTitleTextFieldView: ABTextFieldViewDelegate {
    func configuration(_ textFieldView: ABTextFieldView) -> ABTextFieldViewConfiguration {
        .init(
            backgroundColor: Color.transparent,
            textColor: Color.white,
            font: Pretendard.regular20.font,
            countColor: Color.subPurple.withAlphaComponent(0.6),
            countFont: Pretendard.regular15.font,
            errorColor: Color.subPurple2,
            errorFont: Pretendard.semibold13.font
        )
    }
}
