//
//  ChatView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension TopicDetailCollectionViewCell {
    
    public final class CommentView: BaseView {
        
        private let headerFrame: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(r: 100, g: 81, b: 155)
            return view
        }()
        private let contentFrame: UIView = UIView()
        private let blurView: CustomVisualEffectView = CustomVisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.06)
        private let contentCell: RepresentativeCommentView = RepresentativeCommentView()
        private let induceSelectChip: PaddingLabel = {
            let label = PaddingLabel(topBottom: 4, leftRight: 14)
            label.backgroundColor = Color.subPurple
            label.text = "선택하고 댓글보기"
            label.textColor = Color.white
            label.setTypo(Pretendard.bold15)
            label.layer.cornerRadius = 29/2
            label.layer.masksToBounds = true
            return label
        }()
        private let induceWriteCommentLabel: UILabel = {
           let label = UILabel()
            label.text = "선택 후 가장 먼저 댓글을 작성해 보세요!"
            label.setTypo(Pretendard.regular14)
            label.textColor = Color.white60
            return label
        }()
        private let countStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 12)
        let chatCountFrame: CountStackView = CountStackView(explain: "의 댓글")
        let likeCountFrame: CountStackView = CountStackView(explain: "이 선택했어요")
        
        public override func style() {
            backgroundColor = Color.subNavy2
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
        public override func hierarchy() {
            
            outline()
            header()
            content()
            
            func outline() {
                addSubviews([headerFrame, contentFrame])
            }
            func header() {
                headerFrame.addSubviews([countStackView])
                countStackView.addArrangedSubviews([chatCountFrame, likeCountFrame])
            }
            func content() {
                contentFrame.addSubviews([induceWriteCommentLabel, contentCell, blurView, induceSelectChip])
            }
        }
        public override func layout() {
            
            outline()
            header()
            content()
            
            func outline() {
                headerFrame.snp.makeConstraints{
                    $0.top.leading.trailing.equalToSuperview()
                }
                contentFrame.snp.makeConstraints{
                    $0.top.equalTo(headerFrame.snp.bottom)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
            }
            
            func header() {
                countStackView.snp.makeConstraints{
                    $0.top.bottom.equalToSuperview().inset(10)
                    $0.leading.equalToSuperview().offset(16)
                }
            }
            
            func content() {
                blurView.snp.makeConstraints{
                    $0.top.leading.trailing.bottom.equalToSuperview()
                }
                induceSelectChip.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(14)
                    $0.centerX.centerY.equalToSuperview()
                    $0.height.equalTo(29)
                }
                contentCell.snp.makeConstraints{
                    $0.top.bottom.equalToSuperview().inset(14)
                    $0.leading.trailing.equalToSuperview()
                }
                induceWriteCommentLabel.snp.makeConstraints{
                    $0.center.equalToSuperview()
                }
            }
        }
        
        ///댓글 개수가 0인 경우
        public func empty(isVoted: Bool) {
            induceWriteCommentLabel.isHidden = false
            chatCountFrame.isHidden = true
            contentCell.isHidden = true
            [blurView, induceSelectChip].forEach{
                $0.isHidden = true
            }
            isUserInteractionEnabled = isVoted
        }
        
        public func fill(comment: Comment?, isVoted: Bool) {
            
            let (subviewHidden,isInteractionEnabled) = {
                if comment == nil {
                    return (true, false)
                }
                else if isVoted {
                    return (true, true)
                }
                else {
                    return (false, false)
                }
            }()

            contentCell.isHidden = false
            chatCountFrame.isHidden = false
            induceWriteCommentLabel.isHidden = true
            [blurView, induceSelectChip].forEach{
                $0.isHidden = subviewHidden
            }
            isUserInteractionEnabled = isInteractionEnabled
//            contentCell.profileImageView.image =
            contentCell.contentLabel.text = comment?.content
        }
    }
}

extension TopicDetailCollectionViewCell.CommentView {
    
    final class RepresentativeCommentView: BaseView {
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.layer.cornerRadius = 22/2
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = UIColor(217)
            return imageView
        }()
        let contentLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular15)
            label.textColor = Color.white
            return label
        }()
        
        override func hierarchy() {
            addSubviews([profileImageView, contentLabel])
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
}

extension TopicDetailCollectionViewCell.CommentView {
    
    class CountStackView: BaseStackView {
        
        init(explain: String) {
            super.init()
            explainLabel.text = explain
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let countLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold14)
            return label
        }()
        
        private let explainLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.semibold14)
            return label
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 1
        }
        
        override func hierarchy() {
            addArrangedSubviews([countLabel, explainLabel])
        }
        
        func binding(_ count: String) {
            countLabel.text = count
        }
    }
}
