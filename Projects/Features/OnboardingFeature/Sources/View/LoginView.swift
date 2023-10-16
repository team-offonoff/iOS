//
//  LoginView.swift
//  OnboardingFeatureDemo
//
//  Created by 박소윤 on 2023/10/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import AuthenticationServices

class LoginView: BaseView {
    
    let buttonFrame: ButtonFrame = ButtonFrame()
    
    override func hierarchy() {
        addSubviews([buttonFrame])
    }
    
    override func layout() {
        buttonFrame.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}

extension LoginView {
    
    class ButtonFrame: BaseStackView {
        
        lazy var kakaoLoginButton: UIButton = {
            let button = UIButton()
            button.setTitle("카카오", for: .normal)
            button.setTitleColor(.yellow, for: .normal)
            return button
        }()
        lazy var appleLoginButton: ASAuthorizationAppleIDButton = {
            let button = ASAuthorizationAppleIDButton(type: .default, style: .black)
            return button
        }()
        
        override func style() {
            axis = .vertical
            spacing = 20
        }
        
        override func hierarchy() {
            addArrangedSubviews([kakaoLoginButton, appleLoginButton])
            appleLoginButton.snp.makeConstraints{
                $0.height.equalTo(50)
            }
        }
    }
}
