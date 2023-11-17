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
import Core

extension Gender: RadioButtonData {
    public var title: String {
        rawValue
    }
}

public final class SignUpView: BaseView {
    
    private let frameStackView: UIStackView = UIStackView(axis: .vertical, spacing: 20)
    let nicknameFrame: TextFieldFrame = TextFieldFrame()
    let birthdayFrame: TextFieldFrame = {
        let frame = TextFieldFrame()
        frame.textField.keyboardType = .numberPad
        return frame
    }()
    let genderFrame: RadioButtonView = {
        let view = RadioButtonView(elements: Gender.allCases, cellType: GenderRadioButtonCell.self)
        view.axis = .horizontal
        view.spacing = 10
        view.distribution = .equalSpacing
        return view
    }()
    let jobFrame: DropDownFrame = DropDownFrame()
    
    public override func hierarchy() {
        addSubviews([frameStackView])
        frameStackView.addArrangedSubviews([nicknameFrame, birthdayFrame, genderFrame, jobFrame])
    }
    
    public override func layout() {
        frameStackView.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(50)
        }
    }
}

extension SignUpView {
    
    final class TextFieldFrame: BaseStackView {
        let textField: UITextField = {
            let textfield = UITextField()
            textfield.layer.borderColor = Color.black20.cgColor
            textfield.layer.borderWidth = 1
            return textfield
        }()
        override func hierarchy() {
            addArrangedSubview(textField)
        }
    }
    
    final class DropDownFrame: BaseStackView {
        let textField: UITextField = {
            let textfield = UITextField()
            textfield.layer.borderColor = Color.black20.cgColor
            textfield.layer.borderWidth = 1
            return textfield
        }()
        override func hierarchy() {
            addArrangedSubview(textField)
        }
    }
    
    final class GenderRadioButtonCell: BaseView, RadioButtonCell {
        
        var titleLabel: UILabel = UILabel()
        
        override func style() {
            layer.borderWidth = 1
        }
        
        override func hierarchy() {
            addSubviews([titleLabel])
        }
        
        override func layout() {
            titleLabel.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(20)
                $0.leading.trailing.equalToSuperview().inset(50)
            }
        }
        
        func select() {
            layer.borderColor = UIColor.black.cgColor
            titleLabel.textColor = .black
        }
        
        func deselect() {
            layer.borderColor = UIColor.gray.cgColor
            titleLabel.textColor = .gray
        }
    }
}
