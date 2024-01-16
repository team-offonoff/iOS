//
//  MyPageView.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class MyPageView: BaseView {
    private let profileStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 30)
        stackView.alignment = .center
        return stackView
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = Color.white
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(102)
        }
        imageView.layer.cornerRadius = 102/2
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let imageModifyButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.modifyProfileImage, for: .normal)
        button.snp.makeConstraints{
            $0.width.height.equalTo(35)
        }
        return button
    }()
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = Color.white
        label.setTypo(Pretendard.semibold22)
        return label
    }()
    
    private let sectionStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 32)
        stackView.alignment = .leading
        return stackView
    }()
    let modifyInformationSection: ModifyInformationSection = ModifyInformationSection()
    private let separatorLine1: SeparatorLine = SeparatorLine(color: Color.white.withAlphaComponent(0.1), height: 1)
    let termSection: UILabel = {
        let label = UILabel()
        label.text = "약관"
        label.textColor = Color.white
        label.setTypo(Pretendard.regular16)
        return label
    }()
    let versionSection: VersionSection = VersionSection()
    private let separatorLine2: SeparatorLine = SeparatorLine(color: Color.white.withAlphaComponent(0.1), height: 1)
    let logoutSection: UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        label.textColor = Color.white40
        label.setTypo(Pretendard.regular16)
        return label
    }()
    
    override func hierarchy() {
        addSubviews([profileStackView, sectionStackView])
        profileStackView.addArrangedSubviews([profileImageView, nicknameLabel])
        profileStackView.addSubview(imageModifyButton)
        sectionStackView.addArrangedSubviews([modifyInformationSection, separatorLine1, termSection, versionSection, separatorLine2, logoutSection])
    }
    
    override func layout() {
        profileStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        imageModifyButton.snp.makeConstraints{
            $0.trailing.bottom.equalTo(profileImageView).inset(3)
        }
        sectionStackView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        [separatorLine1, separatorLine2].forEach{ view in
            view.snp.makeConstraints{
                $0.width.equalToSuperview()
            }
        }
    }
}

extension MyPageView {
    
    final class ModifyInformationSection: BaseStackView {
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "내 정보 수정"
            label.textColor = Color.white
            label.setTypo(Pretendard.regular16)
            return label
        }()
        private let moveButton: UIImageView = {
           let imageView = UIImageView()
            imageView.image = Image.down.withTintColor(Color.white40)
            imageView.transform = imageView.transform.rotated(by: .pi/2*3)
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(20)
            }
            return imageView
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 3
            isUserInteractionEnabled = true
            alignment = .center
        }
        
        override func hierarchy() {
            addArrangedSubviews([titleLabel, moveButton])
        }
    }
    
    final class VersionSection: BaseStackView {
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "버전 정보"
            label.textColor = Color.white
            label.setTypo(Pretendard.regular16)
            return label
        }()
        
        let versionLabel: UILabel = {
            let label = UILabel()
            label.text = "ver 1.0"
            label.textColor = Color.subPurple
            label.setTypo(Pretendard.regular15)
            return label
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 10
        }
        
        override func hierarchy() {
            addArrangedSubviews([titleLabel, versionLabel])
        }
    }
}
