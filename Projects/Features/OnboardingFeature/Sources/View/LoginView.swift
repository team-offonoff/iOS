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
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Image.logo)
        return imageView
    }()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "세상의 모든 질문,\nAB로 답하다"
        label.setTypo(Pretendard.semibold24, setLineSpacing: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Color.white
        return label
    }()
    private let easySignUpStacKView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: 18)
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private let leftLineView: UIView = {
        let line = UIView()
        line.backgroundColor = Color.white60
        line.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        return line
    }()
    private let easySignUpLabel: UILabel = {
        let label = UILabel()
        label.text = "간편 가입하기"
        label.textColor = Color.white
        label.setTypo(Pretendard.regular15)
        return label
    }()
    private let rightLineView: UIView = {
        let line = UIView()
        line.backgroundColor = Color.white60
        line.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        return line
    }()
    
    let buttonGroup: ButtonGroup = ButtonGroup()
    
    
    override func hierarchy() {
        addSubviews([logoImageView, titleLabel, easySignUpStacKView, buttonGroup])
        easySignUpStacKView.addArrangedSubviews([leftLineView, easySignUpLabel, rightLineView])
    }
    
    override func layout() {
        logoImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(125)
            $0.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        easySignUpStacKView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        rightLineView.snp.makeConstraints{
            $0.width.equalTo(leftLineView)
        }
        buttonGroup.snp.makeConstraints{
            $0.top.equalTo(easySignUpStacKView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
}

extension LoginView {
    
    class ButtonGroup: BaseStackView {
        
        let kakaoLogin: SocialLoginButton = SocialLoginButton(icon: Image.loginKakao, title: "카카오로 계속하기", backgroundColor: UIColor(r: 254, g: 229, b: 0), textColor: Color.black)
        let appleLogin: SocialLoginButton = SocialLoginButton(icon: Image.loginApple, title: "애플로 계속하기", backgroundColor: Color.black, textColor: Color.white)
        
        override func style() {
            axis = .vertical
            spacing = 17
        }
        
        override func hierarchy() {
            addArrangedSubviews([kakaoLogin, appleLogin])
        }
    }
    
    class SocialLoginButton: BaseView {
        
        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(18)
            }
            return imageView
        }()
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.bold16)
            return label
        }()
        
        init(icon: UIImage, title: String, backgroundColor: UIColor, textColor: UIColor){
            super.init()
            iconImageView.image = icon
            titleLabel.text = title
            titleLabel.textColor = textColor
            self.backgroundColor = backgroundColor
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func style() {
            layer.cornerRadius = 10
        }
        
        override func hierarchy() {
            addSubviews([iconImageView, titleLabel])
        }
        
        override func layout() {
            iconImageView.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(20)
                $0.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(15)
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
}
