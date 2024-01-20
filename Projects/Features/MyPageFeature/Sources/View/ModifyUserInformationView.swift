//
//  ModifyUserInformationView.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ModifyUserInformationView: BaseView {
    
    private let backgroundStackView: UIStackView = UIStackView(axis: .vertical, spacing: 24)
    private let informationStackView: UIStackView = {
       let stackView = UIStackView(axis: .vertical, spacing: 10)
        stackView.alignment = .leading
        return stackView
    }()
    let birthInformationView: ETCInformationStackView = ETCInformationStackView(title: "생년월일")
    let genderInformationView: ETCInformationStackView = ETCInformationStackView(title: "성별")
    
    let separatorLine: UIView = {
       let view = UIView()
        view.backgroundColor = Color.white20
        view.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        return view
    }()
    
    let nicknameView: SubtitleView<ABTextFieldView> = SemiboldSubtitleView(subtitle: "변경할 닉네임을 입력해 주세요", content: ABTextFieldView(placeholder: "한글, 영문, 숫자 최대 8자", insets: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 45), isErrorNeed: true))
    let jobView: SubtitleView<DropDownView> = SemiboldSubtitleView(subtitle: "변경할 직업을 선택해주세요.", content: DropDownView(placeholder: "직업 선택하기"))
    
    let ctaButton: CTAButton = CTAButton(title: "변경하기")
    
    override func hierarchy() {
        addSubviews([backgroundStackView, ctaButton])
        backgroundStackView.addArrangedSubviews([informationStackView, separatorLine, nicknameView, jobView])
        informationStackView.addArrangedSubviews([birthInformationView, genderInformationView])
    }
    
    override func layout() {
        backgroundStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        ctaButton.snp.makeConstraints{
            $0.top.greaterThanOrEqualTo(backgroundStackView)
            $0.leading.trailing.equalToSuperview().inset(ctaButton.defaultOffset.side)
            $0.bottom.equalToSuperview().inset(ctaButton.defaultOffset.bottom)
        }
    }
}

extension ModifyUserInformationView {
    
    final class ETCInformationStackView: BaseStackView {
        
        init(title: String) {
            super.init()
            titleLabel.text = title
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white40
            label.setTypo(Pretendard.semibold14)
            return label
        }()
        
        let informationLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular14)
             return label
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 12
        }
        
        override func hierarchy() {
            addArrangedSubviews([titleLabel, informationLabel])
        }
    }
}
