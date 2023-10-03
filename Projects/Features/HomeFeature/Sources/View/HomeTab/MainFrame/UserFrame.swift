//
//  UserFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit

extension HomeTabView {

    final class UserFrame: BaseView {
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(188)
            imageView.layer.cornerRadius = 20/2
            imageView.layer.masksToBounds = true
            return imageView
        }()
        
        let nicknameLabel: UILabel = {
            let label = UILabel()
            label.text = "체리체리체리체리"
            label.textColor = Color.white
            label.setTypo(Pretendard.bold18)
            return label
        }()
        
        private let etcNicknameTextLabel: UILabel = {
            let label = UILabel()
            label.text = "님의 토픽"
            label.textColor = Color.white
            label.setTypo(Pretendard.regular18)
            return label
        }()
        
        private let profileStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 8)
        private let nicknameStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 2)
        
        override func hierarchy() {
            addSubviews([profileStackView])
            profileStackView.addArrangedSubviews([profileImageView, nicknameStackView])
            nicknameStackView.addArrangedSubviews([nicknameLabel, etcNicknameTextLabel])
        }
        
        override func layout() {
            profileStackView.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.bottom.lessThanOrEqualToSuperview()
            }
            profileImageView.snp.makeConstraints{
                $0.width.height.equalTo(20)
            }
        }
    }
    
}
