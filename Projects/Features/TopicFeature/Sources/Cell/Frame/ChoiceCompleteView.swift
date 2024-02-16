//
//  SelectionCompleteView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/01.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

extension TopicDetailCollectionViewCell {
    
    public final class ChoiceCompleteView: BaseView {
        
        private let completeTagLabel: PaddingLabel = {
            let label = PaddingLabel(topBottom: 3, leftRight: 13)
            label.backgroundColor = Color.subNavy2
            label.text = "선택 완료"
            label.textColor = Color.white
            label.setTypo(Pretendard.bold15)
            label.layer.cornerRadius = 27/2
            label.layer.masksToBounds = true
            label.snp.makeConstraints{
                $0.height.equalTo(27)
            }
            return label
        }()
        private let contentView: UIView = UIView()
        private let contentLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.semibold20, setLineSpacing: true)
            label.numberOfLines = 0
            label.textColor = Color.white
            label.textAlignment = .center
            return label
        }()
        private let choiceLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.black200)
            return label
        }()

        public override func style() {
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
        }
        
        public override func hierarchy() {
            addSubviews([contentView, completeTagLabel])
            contentView.addSubviews([choiceLabel, contentLabel])
        }
        
        public override func layout() {
            completeTagLabel.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
            contentView.snp.makeConstraints{
                $0.top.equalTo(completeTagLabel.snp.centerY)
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(148)
            }
            contentLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(46)
                $0.leading.equalToSuperview().offset(38)
                $0.centerX.centerY.equalToSuperview()
            }
            choiceLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview().offset(25)
                $0.centerX.equalToSuperview()
            }
        }
        
        func fill(choice: Choice) {
            contentView.backgroundColor = choice.option.content.color.withAlphaComponent(0.2)
            contentLabel.text = choice.content.text
            choiceLabel.textColor = choice.option.content.color.withAlphaComponent(0.4)
            choiceLabel.text = choice.option.content.title
        }
    }
}
