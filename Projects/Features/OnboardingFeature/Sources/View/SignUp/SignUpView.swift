//
//  SignUpView.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2023/11/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import Domain

extension Gender: RadioButtonData {
    public var title: String {
        rawValue
    }
}

public final class SignUpView: BaseView {
    
    let nicknameView: SubtitleView<ABTextFieldView> = {
        let subview = SubtitleView(
            subtitle: "AB에서 사용할 닉네임을 정해주세요.",
            content: ABTextFieldView(placeholder: "한글, 영문, 숫자 최대 8자", insets: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15), isErrorNeed: true)
        )
        subview.contentView.textField.customPlaceholder(font: Pretendard.semibold14.font)
        return subview
    }()
    let birthdayView: SubtitleView<ABTextFieldView> = {
        let subview = SubtitleView(
            subtitle: "생년월일을 입력해주세요.",
            content: ABTextFieldView(placeholder: "YYYY/MM/DD", insets: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 15), isErrorNeed: true)
        )
        subview.contentView.textField.customPlaceholder(font: Pretendard.semibold14.font)
        subview.contentView.textField.keyboardType = .numberPad
        return subview
    }()
    let genderView: SubtitleView<RadioButtonView> = {
        let view = SubtitleView(
            subtitle: "성별을 선택해주세요.",
            content: RadioButtonView(elements: Gender.allCases, cellType: GenderRadioButtonCell.self)
        )
        view.contentView.axis = .horizontal
        view.contentView.spacing = 11
        view.contentView.distribution = .fillEqually
        return view
    }()
    let jobView: SubtitleView<DropDownView> = {
        let view = SubtitleView(subtitle: "직업을 선택해주세요.", content: DropDownView(placeholder: "직업 선택하기"))
        return view
    }()
    let ctaButton: CTAButton = {
        let button = CTAButton(title: "다 입력 했어요")
        button.isEnabled = false
        return button
    }()
    
    public override func hierarchy() {
        addSubviews([nicknameView, birthdayView, genderView, jobView, ctaButton])
    }
    
    public override func layout() {
        nicknameView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(51)
            $0.leading.trailing.equalToSuperview().inset(nicknameView.defaultSideOffset)
        }
        birthdayView.snp.makeConstraints{
            $0.top.equalTo(nicknameView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(birthdayView.defaultSideOffset)
        }
        genderView.snp.makeConstraints{
            $0.top.equalTo(birthdayView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(genderView.defaultSideOffset)
        }
        jobView.snp.makeConstraints{
            $0.top.equalTo(genderView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(jobView.defaultSideOffset)
        }
        ctaButton.snp.makeConstraints{
            $0.top.greaterThanOrEqualTo(jobView.snp.bottom).offset(82)
            $0.bottom.equalToSuperview().inset(ctaButton.defaultOffset.bottom)
            $0.leading.trailing.equalToSuperview().inset(ctaButton.defaultOffset.side)
        }
    }
}

extension SignUpView {
    
    class GenderRadioButtonCell: BaseView, RadioButtonCell {
        
        var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white
            label.setTypo(Pretendard.bold16)
            return label
        }()
        
        override func style() {
            layer.cornerRadius = 10
        }
        
        override func hierarchy() {
            addSubviews([titleLabel])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(59)
            }
            titleLabel.snp.makeConstraints{
                $0.centerX.centerY.equalToSuperview()
            }
        }
        
        func select() {
            backgroundColor = Color.subPurple
        }
        
        func deselect() {
            backgroundColor = Color.subNavy2
        }
    }
}
