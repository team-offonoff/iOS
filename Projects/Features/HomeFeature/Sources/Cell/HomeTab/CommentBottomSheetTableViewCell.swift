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
import Combine
import Domain
import FeatureDependency
import HomeFeatureInterface

final class CommentBottomSheetTableViewCell: BaseTableViewCell {
    
    weak var delegate: TapDelegate?
    
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
    private let likeContent: LikeContentView = LikeContentView(state: .like)
    private let dislikeContent: LikeContentView = LikeContentView(state: .dislike)
    private var cancellable: Set<AnyCancellable> = []
    
    override func prepareForReuse() {
        choiceLabel.textColor = Color.white
        choiceLabel.text = ""
        state(isLike: false, count: "0")
        state(isDislike: false)
    }
    
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
    
    override func initialize() {
        likeContent.button.tapPublisher
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.tap(.init(identifier: Comment.State.like.identifier, data: self.indexPath))
            }
            .store(in: &cancellable)
        
        dislikeContent.button.tapPublisher
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.tap(.init(identifier: Comment.State.dislike.identifier, data: self.indexPath))
            }
            .store(in: &cancellable)
        
        moreButton.tapPublisher
            .sink{ [weak self] _ in
                guard let self = self else { return }
                self.delegate?.tap(.init(identifier: Comment.Action.tapEtc.identifier, data: self.indexPath))
            }
            .store(in: &cancellable)
    }
    
    func fill(_ comment: CommentListItemViewModel) {
        nicknameLabel.text = comment.nickname
        dateLabel.text = comment.elapsedTime
        choiceLabel.textColor = (comment.selectedOption.option?.content.color ?? Color.subNavy).withAlphaComponent(0.6)
        choiceLabel.text = comment.selectedOption.content
        contentLabel.text = comment.content
        state(isLike: comment.isLike, count: comment.countOfLike)
        state(isDislike: comment.isHate)
    }
    
    func state(isLike: Bool, count: String) {
        likeContent.button.isSelected = isLike
        likeContent.countLabel.text = count
    }
    
    func state(isDislike: Bool) {
        dislikeContent.button.isSelected = isDislike
    }
}

extension CommentBottomSheetTableViewCell {
    
    private class LikeContentView: BaseStackView {
        
        private let state: Comment.State
        
        init(state: Comment.State) {
            self.state = state
            super.init()
            setButtonImage()
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let button: UIButton = {
            let button = UIButton()
            button.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return button
        }()
        let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.black60
            label.setTypo(Pretendard.regular13)
            return label
        }()
        
        private var cancellable: Set<AnyCancellable> = []
        
        override func style() {
            axis = .horizontal
            spacing = 3
            alignment = .center
        }
        
        override func hierarchy() {
            addArrangedSubviews([button, countLabel])
        }
        
        private func setButtonImage() {
            button.setImage(state.content.activateIcon, for: .selected)
            button.setImage(state.content.defaultIcon, for: .normal)
        }
    }
}
