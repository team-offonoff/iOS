//
//  ChatBottomSheetTableViewCell.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/09.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

final class ChatBottomSheetTableViewCell: BaseTableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(85)
        imageView.layer.cornerRadius = 22/2
        imageView.snp.makeConstraints{
            $0.width.height.equalTo(22)
        }
        return imageView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: 5)
        stackView.alignment = .center
        return stackView
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black60
        label.setTypo(Pretendard.regular14)
        return label
    }()
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.black40
        view.layer.cornerRadius = 2/2
        view.snp.makeConstraints{
            $0.width.height.equalTo(2)
        }
        return view
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.black40
        label.setTypo(Pretendard.regular14)
        return label
    }()

    private let choiceLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.semibold14)
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.dot.withTintColor(Color.black40), for: .normal)
        button.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Color.black40
        label.setTypo(Pretendard.medium15)
        return label
    }()
    
    private let likeStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 12)
    private let likeContent: LikeContentView = LikeContentView(icon: Image.chatLike)
    private let dislikeContent: LikeContentView = LikeContentView(icon: Image.chatDislike)
    
    override func hierarchy() {
        topStackView.addArrangedSubviews([nicknameLabel, dotView, dateLabel])
        likeStackView.addArrangedSubviews([likeContent, dislikeContent])
        baseView.addSubviews([profileImageView, topStackView, choiceLabel, contentLabel, likeStackView, moreButton])
    }
    
    override func layout() {
        profileImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(19.5)
        }
        topStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        choiceLabel.snp.makeConstraints{
            $0.top.equalTo(topStackView.snp.bottom).offset(2)
            $0.leading.equalTo(topStackView)
        }
        moreButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().inset(20)
        }
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(choiceLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().inset(30)
        }
        likeStackView.snp.makeConstraints{
            $0.top.equalTo(contentLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    func fill() {
        nicknameLabel.text = "닉네임"
        dateLabel.text = "2일전"
        choiceLabel.text = "A. 10년 전 과거로 가기"
        contentLabel.text = "왜들 그리 다운돼있어? 뭐가 문제야 say something 분위기가 겁나 싸해 요새는 이런 게 유행인가 왜들 그리 재미없어? 아 그건 나도 마찬가지"
        likeContent.countLabel.text = "129"
    }
}

extension ChatBottomSheetTableViewCell {
    
    private class LikeContentView: BaseStackView {
        
        init(icon: UIImage) {
            super.init()
            iconImageView.image = icon
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return imageView
        }()
        
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black60
            label.setTypo(Pretendard.regular13)
            return label
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 3
            alignment = .center
        }
        
        override func hierarchy() {
            addArrangedSubviews([iconImageView, countLabel])
        }
    }
}
