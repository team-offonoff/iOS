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
import SideAFeatureInterface
import FeatureDependency
import Domain

final class SideATopicTableViewCell: BaseTableViewCell {
    
    weak var delegate: VoteDelegate?
    
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
        label.numberOfLines = 2
        return label
    }()
    private let etcButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.more, for: .normal)
        button.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        button.isHidden = true //1차 스펙 아웃
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
        baseView.addSubviews([tagStackView, separatorLine])
        tagStackView.addArrangedSubviews([topicTag, contentStackView])
        contentStackView.addSubviews([titleLabel, etcButton, voteSection, timeLabel, commentSection])
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
            $0.trailing.lessThanOrEqualTo(etcButton).inset(77)
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
    
    override func initialize() {
        voteSection.options.forEach{
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOption)))
        }
        commentSection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapComment)))
    }
    
    @objc private func tapOption(_ recognizer: UITapGestureRecognizer) {
        guard let view = recognizer.view as? ChoiceView, let indexPath = indexPath else { return }
        delegate?.vote(view.option, index: indexPath.row)
    }
    
    @objc private func tapComment(_ recognizer: UITapGestureRecognizer) {
        guard let indexPath = indexPath, let superview = superview as? UITableView else { return }
        NotificationCenter.default.post(name: Notification.Name(Comment.Action.showBottomSheet.identifier), object: superview, userInfo: ["Index": indexPath.row])
    }
    
    func fill(topic: SideATopicItemViewModel) {
        
        setTag()
        isVoteEnable()
        isCommentEnable()
        titleLabel.text = topic.title
        timeLabel.text = topic.elapsedTime
        voteSection.optionA.fill(topic: topic)
        voteSection.optionB.fill(topic: topic)
        commentSection.fill(topic.commentCount)

        func setTag() {
            if let tag = topic.tag() {
                topicTag.fill(tag.configuration)
            }
            else {
                topicTag.isHidden = true
            }
        }

        func isVoteEnable() {
            voteSection.isUserInteractionEnabled = !topic.isVoted
        }
        
        func isCommentEnable() {
            commentSection.isUserInteractionEnabled = topic.isVoted
        }
    }
}

extension SideATopicTableViewCell {
    
    final class VoteSection: BaseStackView {
        
        let optionA: ChoiceView = ChoiceView(option: .A, leadingOffset: 16)
        let optionB: ChoiceView = ChoiceView(option: .B, leadingOffset: 17)
        
        var options: [ChoiceView] {
            [optionA, optionB]
        }
        
        override func style() {
            axis = .vertical
            spacing = 5
        }
        
        override func hierarchy() {
            addArrangedSubviews([optionA, optionB])
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
