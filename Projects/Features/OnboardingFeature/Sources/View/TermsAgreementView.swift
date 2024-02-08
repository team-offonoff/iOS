//
//  TermsAgreementView.swift
//  OnboardingFeature
//
//  Created by 박소윤 on 2024/01/13.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain
import Combine

final class TermsAgreementView: BaseView {
    
    let allAgreement: AgreementCell = {
        let stackView = AgreementCell(term: .serviceUse) //이미 만들어져있는 UI를 재사용하기 위해 임의로 약관을 주입
        stackView.titleLabel.text = "모두 동의하기"
        stackView.moveButton.isHidden = true
        return stackView
    }()
    let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Color.black20
        view.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        return view
    }()
    private let agreementStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 26)
        stackView.alignment = .leading
        return stackView
    }()
    var agreementCells: [AgreementCell] {
        agreementStackView.subviews.compactMap{ $0 as? AgreementCell }
    }
    let ctaButton: CTAButton = {
        let button = CTAButton(title: "AB 시작하기")
        button.isEnabled = false
        return button
    }()
    
    override func hierarchy() {
        addSubviews([allAgreement, separatorLine, agreementStackView, ctaButton])
        Term.allCases.forEach{ term in
            let termView = AgreementCell(term: term)
            agreementStackView.addArrangedSubview(termView)
        }
    }
    
    override func layout() {
        allAgreement.snp.makeConstraints{
            $0.top.equalToSuperview().offset(48)
            $0.leading.equalToSuperview().offset(32)
        }
        separatorLine.snp.makeConstraints{
            $0.top.lessThanOrEqualTo(allAgreement.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        agreementStackView.snp.makeConstraints{
            $0.top.equalTo(separatorLine.snp.bottom).offset(26)
            $0.leading.equalToSuperview().offset(32)
        }
        ctaButton.snp.makeConstraints{
            $0.top.equalTo(agreementStackView.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(ctaButton.defaultOffset.side)
            $0.bottom.equalToSuperview().inset(ctaButton.defaultOffset.bottom)
        }
    }
}

extension TermsAgreementView {
    
    final class AgreementCell: BaseView {
        
        init(term: Term) {
            self.term = term
            super.init()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let term: Term
        var isChecked: Bool {
            get {
                agreementButton.isSelected
            }
            set {
                agreementButton.isSelected = newValue
            }
        }
        let agreementButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.checkbox, for: .normal)
            button.setImage(Image.checkboxFill, for: .selected)
            button.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return button
        }()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black
            label.setTypo(Pretendard.regular16)
            return label
        }()
        let moveButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.down.withTintColor(Color.black40), for: .normal)
            button.transform = button.transform.rotated(by: .pi/2*3)
            button.snp.makeConstraints{
                $0.width.height.equalTo(20)
            }
            return button
        }()
        
        override func hierarchy() {
            addSubviews([agreementButton, titleLabel, moveButton])
        }
        
        override func layout() {
            agreementButton.snp.makeConstraints{
                $0.leading.top.bottom.equalToSuperview()
            }
            titleLabel.snp.makeConstraints{
                $0.leading.equalTo(agreementButton.snp.trailing).offset(16)
                $0.top.bottom.equalToSuperview()
            }
            moveButton.snp.makeConstraints{
                $0.leading.equalTo(titleLabel.snp.trailing).offset(3)
                $0.centerY.trailing.equalToSuperview()
            }
        }

        override func initialize() {
            
            titleLabel.text = "\(term.title)(\(option()))"
            
            func option() -> String {
                term.isEssential ? "필수" : "선택"
            }
        }
    }
}
