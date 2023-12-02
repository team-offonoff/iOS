//
//  HomeTabView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import ABKit
import UIKit
import Domain
import FeatureDependency
import Core

class HomeTopicCollectionViewCell: BaseCollectionViewCell, Binding{
    
    private let topic: TopicGroup = TopicGroup()
    private let user: UserGroup = UserGroup()
    private let selection: SelectionGroup = SelectionGroup()
    private let etc: EtcGroup = EtcGroup()
    private let chat: ChatView = ChatView()
    
    private let profileStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 8)
    private let choiceStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 15)
    private let informationStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 7)
    
    override func hierarchy() {

        baseView.addSubviews([etc.realTimeTitleLabel, topic.titleLabel, profileStackView, choiceStackView, selection.completeView, topic.timer, selection.slideExplainView, informationStackView, etc.declareButton, chat])
        
        profileStackView.addArrangedSubviews([user.profileImageView, user.nicknameLabel])
        
        choiceStackView.addArrangedSubviews([selection.aChoiceView, selection.bChoiceView])

        informationStackView.addArrangedSubviews([topic.sideLabel, etc.separatorLine, topic.keywordLabel])
    }
    
    override func layout() {
        
        etc.realTimeTitleLabel.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
        }
        
        topic.titleLabel.snp.makeConstraints{
            $0.top.equalTo(etc.realTimeTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(102)
        }
        
        profileStackView.snp.makeConstraints{
            $0.top.equalTo(topic.titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        choiceStackView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview()
        }
        
        selection.aChoiceView.snp.makeConstraints{
            $0.width.equalTo(selection.bChoiceView)
        }
        
        selection.completeView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        topic.timer.snp.makeConstraints{
            $0.top.equalTo(choiceStackView.snp.bottom).offset(43)
            $0.centerX.equalToSuperview()
        }
        
        selection.slideExplainView.snp.makeConstraints{
            $0.top.equalTo(topic.timer.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        informationStackView.snp.makeConstraints{
            $0.top.equalTo(selection.slideExplainView.snp.bottom).offset(43)
            $0.leading.equalToSuperview().offset(20)
        }
        
        etc.declareButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(informationStackView)
        }
        
        chat.snp.makeConstraints{
            $0.top.equalTo(informationStackView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func binding(data: Topic) {
        selection.completeView.isHidden = true
        topic.titleLabel.text = data.title
        topic.sideLabel.text = "A 사이드"
        topic.keywordLabel.text = "대표 키워드"
        selection.aChoiceView.contentLabel.text = data.choices.first(where: { $0.option == .A })?.content.text
        selection.bChoiceView.contentLabel.text = data.choices.first(where: { $0.option == .B })?.content.text
        chat.chatCountFrame.binding("1천 개")
        chat.likeCountFrame.binding("1.2천 명")
    }
    
    func binding(timer: TimerInfo) {
        topic.timer.binding(data: timer)
    }
    
    func select(choice: Choice){
        selection.completeView.fill(choice: choice)
        selection.completeView.isHidden = false
        selection.slideExplainView.isHidden = true
        choiceStackView.isHidden = true
        chat.canUserInteraction = true
        
    }
}

extension HomeTopicCollectionViewCell {
    
    final class TopicGroup {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 2
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold24)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.snp.makeConstraints{
                $0.height.equalTo(68)
            }
            return label
        }()
        let timer: TimerView = TimerView()
        let sideLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular13)
            label.textColor = Color.subPurple
            return label
        }()
        let keywordLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular13)
            label.textColor = Color.white60
            return label
        }()
    }
    
    final class UserGroup {
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(85)
            imageView.layer.cornerRadius = 22/2
            imageView.layer.masksToBounds = true
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return imageView
        }()
        let nicknameLabel: UILabel = {
            let label = UILabel()
            label.text = "체리체리체리체리"
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular14)
            return label
        }()
    }
    
    final class SelectionGroup {
        let completeView: SelectionCompleteView = SelectionCompleteView()
        let aChoiceView = ChoiceView(choice: .A)
        let bChoiceView = ChoiceView(choice: .B)
        lazy var slideExplainView: UIView = {
            let view = UIView()
            view.addSubviews([leftSlideImageView, rightSlideImageView, slideExplainLabel])
            leftSlideImageView.snp.makeConstraints{
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            rightSlideImageView.snp.makeConstraints{
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            slideExplainLabel.snp.makeConstraints{
                $0.top.bottom.equalToSuperview()
                $0.leading.equalTo(leftSlideImageView.snp.trailing).offset(6)
                $0.trailing.equalTo(rightSlideImageView.snp.leading).offset(-6)
            }
            return view
        }()
        private let leftSlideImageView: UIImageView = {
            let view = UIImageView(image: Image.slide)
            view.snp.makeConstraints{
                $0.width.height.equalTo(10)
            }
            return view
        }()
        private let rightSlideImageView: UIImageView = {
            let view = UIImageView(image: Image.slide.withHorizontallyFlippedOrientation())
            view.snp.makeConstraints{
                $0.width.height.equalTo(10)
            }
            return view
        }()
        private let slideExplainLabel: UILabel = {
            let label = UILabel()
            label.text = "밀어서 선택하기"
            label.textColor = Color.white40
            label.setTypo(Pretendard.semibold13)
            return label
        }()
    }
    
    final class EtcGroup {
        let realTimeTitleLabel: UILabel = {
            let label = UILabel()
            label.text = "실시간 인기 토픽"
            label.setTypo(Pretendard.regular18)
            label.textColor = Color.subPurple
            return label
        }()
        let separatorLine: UIView = {
            let view = UIView()
            view.backgroundColor = Color.white20
            view.snp.makeConstraints{
                $0.width.equalTo(1)
                $0.height.equalTo(12)
            }
            return view
        }()
        let declareButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.dot, for: .normal)
            button.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return button
        }()
    }
}

