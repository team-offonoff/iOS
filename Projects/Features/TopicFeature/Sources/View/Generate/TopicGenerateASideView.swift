//
//  TopicGenerateASideView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class TopicGenerateASideView: BaseView {
    
    let titleSection: SubtitleView<TopicTitleTextFieldView> = RegularSubtitleView(
        subtitle: "어떤 주제로 물어볼까요?",
        content: TopicTitleTextFieldView()
    )
    
    let optionsSection: SubtitleView<OptionsStackView> = RegularSubtitleView(
        subtitle: "어떤 선택지가 있나요?",
        content: OptionsStackView()
    )
    let optionSwitch: SwitchView = SwitchView()
    
    let ctaButton: CTAButton = CTAButton(title: "토픽 던지기")
    
    override func hierarchy() {
        addSubviews([titleSection, optionsSection, ctaButton])
        optionsSection.addSubview(optionSwitch)
    }
    
    override func layout() {
        titleSection.snp.makeConstraints{
            $0.top.equalToSuperview().offset(54)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        optionsSection.snp.makeConstraints{
            $0.top.equalTo(titleSection.snp.bottom).offset(39)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        optionSwitch.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview()
        }
        
        ctaButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
}
