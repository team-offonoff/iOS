//
//  ChatTableViewCell.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ChatTableViewCell: BaseTableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 22/2
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(217)
        return imageView
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "나는 10년 전 과거로 가서 주식..."
        label.setTypo(Pretendard.regular15)
        label.textColor = Color.white
        return label
    }()
    
    override func hierarchy() {
        baseView.addSubviews([profileImageView, contentLabel])
    }
    
    override func layout() {
        profileImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        contentLabel.snp.makeConstraints{
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.top.equalToSuperview().offset(4.5)
            $0.bottom.equalToSuperview().inset(3.5)
            $0.trailing.equalToSuperview()
        }
    }
    
}
