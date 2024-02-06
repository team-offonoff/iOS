//
//  SideATopicTableViewCell.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/05.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class SideATopicTableViewCell: BaseTableViewCell {
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 12)
        stackView.alignment = .leading
        return stackView
    }()
    private let topicTag: TopicTagView = TopicTagView()
    
    private let contentStackView: UIStackView = UIStackView(axis: .vertical, spacing: 0)
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.setTypo(Pretendard.medium18)
        label.numberOfLines = 0
        return label
    }()
    private let etcButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.more, for: .normal)
        button.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        return button
    }()
    private let voteSection: VoteSection = VoteSection()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white40
        label.setTypo(Pretendard.regular13)
        label.numberOfLines = 1
        return label
    }()
    private let commentSection: CommentSection = CommentSection()
    private let separatorLine: SeparatorLine = SeparatorLine(color: Color.white20, height: 1)
    
    override func hierarchy() {
        baseView.addSubviews([tagStackView])
        tagStackView.addArrangedSubviews([topicTag, contentStackView])
        contentStackView.addSubviews([titleLabel, etcButton, voteSection, timeLabel, commentSection, separatorLine])
    }
    
    override func layout() {
        tagStackView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview().inset(20)
        }
        contentStackView.snp.makeConstraints{
            $0.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview()
        }
        etcButton.snp.makeConstraints{
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        voteSection.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
        }
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(voteSection.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        commentSection.snp.makeConstraints{
            $0.top.equalTo(voteSection.snp.bottom).offset(14)
            $0.trailing.equalToSuperview()
        }
        separatorLine.snp.makeConstraints{
            $0.top.equalTo(timeLabel.snp.bottom).offset(22)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func fill() {
        topicTag.fill(type: .competition)
        titleLabel.text = "10년 전 또는 후로 갈 수 있다면?"
        voteSection.optionA.fill("10년 전 과거로 가기")
        voteSection.optionB.fill("10년 후 과거로 가기")
        timeLabel.text = "방금"
        commentSection.fill("482")
    }
}

extension SideATopicTableViewCell {
    
    final class VoteSection: BaseStackView {
        
        let optionA: ChoiceView = ChoiceView(option: .A, leadingOffset: 16)
        let optionB: ChoiceView = ChoiceView(option: .B, leadingOffset: 17)
        
        override func style() {
            axis = .vertical
            spacing = 5
        }
        
        override func hierarchy() {
            addArrangedSubviews([optionA, optionB])
        }
        
        final class ChoiceView: BaseView {
            
            init(option: Choice.Option, leadingOffset: CGFloat) {
                self.option = option
                self.leadingOffset = leadingOffset
                super.init()
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private let option: Choice.Option
            private let leadingOffset: CGFloat
            
            private lazy var optionLabel: UILabel = {
                let label = UILabel()
                label.text = option.content.title
                label.textColor = option.content.color
                label.setTypo(Pretendard.black24)
                return label
            }()
            private let choiceLabel: UILabel = {
                let label = UILabel()
                label.textColor = Color.white
                label.setTypo(Pretendard.regular14)
                return label
            }()
            
            override func style() {
                backgroundColor = Color.subNavy2
                layer.cornerRadius = 10
            }
            
            override func hierarchy() {
                addSubviews([optionLabel, choiceLabel])
            }
            
            override func layout() {
                optionLabel.snp.makeConstraints{
                    $0.centerY.equalToSuperview()
                    $0.leading.equalToSuperview().offset(leadingOffset)
                }
                choiceLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(10)
                    $0.centerY.equalToSuperview()
                    $0.leading.equalTo(optionLabel.snp.trailing).offset(10)
                    $0.trailing.lessThanOrEqualToSuperview().inset(10)
                }
            }
            
            func fill(_ content: String) {
                choiceLabel.text = content
            }
        }
    }
    
    final class CommentSection: BaseView {
        private let stackView: UIStackView = UIStackView(axis: .horizontal, spacing: 5)
        private let iconImageView: UIImageView = UIImageView(image: Image.comment)
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "댓글"
            label.textColor = Color.white
            label.setTypo(Pretendard.regular13)
            return label
        }()
        private let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular13)
            return label
        }()
        
        override func style() {
            layer.masksToBounds = true
            layer.cornerRadius = 22/2
            backgroundColor = Color.black40
        }
        
        override func hierarchy() {
            addSubview(stackView)
            stackView.addArrangedSubviews([iconImageView, titleLabel, countLabel])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(22)
            }
            stackView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(2)
                $0.leading.trailing.equalToSuperview().inset(10)
            }
        }
        
        func fill(_ count: String){
            countLabel.text = count
        }
    }
}
