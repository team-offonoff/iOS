//
//  ChatView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit

extension TopicDetailCollectionViewCell {
    
    final class ChatView: BaseView {
        
        var canUserInteraction = false {
            didSet {
                [blurView, induceSelectChip].forEach{
                    $0.isHidden = canUserInteraction
                }
                isUserInteractionEnabled = canUserInteraction
            }
        }
        
        private let headerFrame: UIView = {
           let view = UIView()
            view.backgroundColor = UIColor(r: 100, g: 81, b: 155)
            return view
        }()
        private let contentFrame: UIView = UIView()
        private let blurView: CustomVisualEffectView = CustomVisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.06)
        
        //TODO: replace to table view
        private let contentCell: ChatTableViewCell = ChatTableViewCell()
        
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
        private let countStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 12)
        let chatCountFrame: CountStackView = CountStackView(explain: "의 댓글")
        let likeCountFrame: CountStackView = CountStackView(explain: "이 선택했어요")
        
        override func style() {
            backgroundColor = Color.subNavy2
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
        override func hierarchy() {
            addSubviews([headerFrame, contentFrame])
            headerFrame.addSubviews([countStackView])
            contentFrame.addSubviews([contentCell, blurView, induceSelectChip])
            countStackView.addArrangedSubviews([chatCountFrame, likeCountFrame])
        }
        override func layout() {
            
            headerFrame.snp.makeConstraints{
                $0.top.leading.trailing.equalToSuperview()
            }
            
            countStackView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(10)
                $0.leading.equalToSuperview().offset(16)
            }
            
            contentFrame.snp.makeConstraints{
                $0.top.equalTo(headerFrame.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }
            
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
        }
        
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
}
