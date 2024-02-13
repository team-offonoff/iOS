//
//  SideBTopicItemCell.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/12.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain

final class SideBTopicItemCell: BaseTableViewCell {
    
    private let keywordAndTimeStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 10)
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.subPurple
        label.setTypo(Pretendard.regular13)
        return label
    }()
    private let createdTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white40
        label.setTypo(Pretendard.regular13)
        return label
    }()
    private let voteCompleteChip: PaddingLabel = {
        let label = PaddingLabel(topBottom: 2, leftRight: 12)
        label.text = "선택 완료"
        label.setTypo(Pretendard.semibold13)
        label.textColor = Color.subPurple
        label.backgroundColor = Color.subPurple.withAlphaComponent(0.3)
        label.layer.cornerRadius = 22/2
        label.layer.masksToBounds = true
        label.snp.makeConstraints{
            $0.height.equalTo(22)
        }
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white
        label.numberOfLines = 1
        label.setTypo(Pretendard.semibold18)
        return label
    }()
//    private let etcButton = UIButton = {
//
//    }()
    
    private let choiceOptionSection: SelectionSection = SelectionSection()
    
    private let bottomSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 100, g: 81, b: 155).withAlphaComponent(0.6)
        return view
    }()
    private let voteCountStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 5)
    private let voteCountTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택"
        label.textColor = Color.white80
        label.setTypo(Pretendard.semibold13)
        return label
    }()
    private let voteCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Color.white40
        label.setTypo(Pretendard.semibold13)
        return label
    }()
    private let commentSection: CommentSection = CommentSection()
    
    public override func style() {
        baseView.backgroundColor = Color.subNavy2.withAlphaComponent(0.6)
        baseView.layer.cornerRadius = 10
        baseView.layer.masksToBounds = true
    }
    
    override func hierarchy() {
        baseView.addSubviews([keywordAndTimeStackView, voteCompleteChip, titleLabel, choiceOptionSection, bottomSection])
        bottomSection.addSubviews([voteCountStackView, commentSection])
        keywordAndTimeStackView.addArrangedSubviews([keywordLabel, createdTimeLabel])
        voteCountStackView.addArrangedSubviews([voteCountTitleLabel, voteCountLabel])
    }
    
    override func layout() {
        baseView.snp.remakeConstraints{
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(213)
        }
        keywordAndTimeStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.lessThanOrEqualTo(voteCompleteChip.snp.leading)
        }
        voteCompleteChip.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(22)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(keywordAndTimeStackView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().inset(111)
        }
        choiceOptionSection.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(22)
        }
        bottomSection.snp.makeConstraints{
            $0.top.equalTo(choiceOptionSection.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        voteCountStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().offset(22)
        }
        commentSection.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(9)
            $0.trailing.equalToSuperview().inset(22)
        }
    }
    
    func fill(_ topic: Any) {
        keywordLabel.text = "디자인"
        createdTimeLabel.text = "방금"
        voteCompleteChip.isHidden = false
        titleLabel.text = "나나난나ㅏ나나나나나나나나나나sksksksk"
        choiceOptionSection.optionA.fill("")
        choiceOptionSection.optionB.fill("")
        voteCountLabel.text = "1.2천명"
        commentSection.fill("100")
    }
}

extension SideBTopicItemCell {
    
    final class SelectionSection: BaseStackView {
        
        let optionA: ChoiceView = ChoiceView(option: .A)
        let optionB: ChoiceView = ChoiceView(option: .B)
        
        override func style() {
            axis = .horizontal
            spacing = 5
            distribution = .fillEqually
        }
        
        override func hierarchy() {
            addArrangedSubviews([optionA, optionB])
        }
    }
    
    final class ChoiceView: BaseView {
        
        init(option: Choice.Option){
            super.init()
            optionLabel.textColor = option.content.color.withAlphaComponent(0.6)
            optionLabel.text = option.content.title
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private let optionLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.black20)
            return label
        }()
        
        private let contentLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.semibold13, setLineSpacing: true)
            label.textAlignment = .center
            label.textColor = Color.white40
            label.numberOfLines = 2
            return label
        }()
        private let imageView: UIImageView = {
           let imageView = UIImageView()
            imageView.layer.cornerRadius = 64/2
            imageView.layer.borderWidth = 6
            imageView.layer.borderColor = Color.subNavy2.cgColor
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(64)
            }
            return imageView
        }()
        override func style() {
            layer.cornerRadius = 10
        }
        
        override func hierarchy() {
            addSubviews([optionLabel, contentLabel, imageView])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(72)
            }
            optionLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(3)
                $0.leading.equalToSuperview().offset(6)
            }
            contentLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(21)
            }
            imageView.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(44)
            }
        }
        
        func fill(_ choice: Any) {
            //이미지
            backgroundColor = Color.transparent
            contentLabel.isHidden = true
            imageView.isHidden = false
//            imageView.image =
            
            //텍스트
//            backgroundColor = Color.subNavy2
//            contentLabel.text = "나나나나나나나나나나나나나나나나..."
//            contentLabel.isHidden = false
//            imageView.isHidden = true
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
            backgroundColor = Color.black20
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
