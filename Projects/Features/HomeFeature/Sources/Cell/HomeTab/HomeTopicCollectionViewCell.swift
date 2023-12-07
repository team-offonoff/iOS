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
import HomeFeatureInterface
import Combine

class HomeTopicCollectionViewCell: BaseCollectionViewCell, Binding{
    
    weak var delegate: TopicBottomSheetDelegate?
    private var cancellable: Set<AnyCancellable> = []
    
    private let topicGroup: TopicGroup = TopicGroup()
    private let userGroup: UserGroup = UserGroup()
    private let choiceGroup: ChoiceGroup = ChoiceGroup()
    private let etcGroup: EtcGroup = EtcGroup()
    private let chat: ChatView = ChatView()
    
    private let profileStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 8)
    private let choiceStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 15)
    private let informationStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 7)
    
    override func hierarchy() {

        baseView.addSubviews([etcGroup.realTimeTitleLabel, topicGroup.titleLabel, profileStackView, choiceStackView, choiceGroup.completeView, topicGroup.timer, choiceGroup.slideExplainView, informationStackView, etcGroup.declareButton, chat])
        
        profileStackView.addArrangedSubviews([userGroup.profileImageView, userGroup.nicknameLabel])
        
        choiceStackView.addArrangedSubviews([choiceGroup.aChoiceView, choiceGroup.bChoiceView])

        informationStackView.addArrangedSubviews([topicGroup.sideLabel, etcGroup.separatorLine, topicGroup.keywordLabel])
    }
    
    override func layout() {
        
        etcGroup.realTimeTitleLabel.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
        }
        
        topicGroup.titleLabel.snp.makeConstraints{
            $0.top.equalTo(etcGroup.realTimeTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(102)
        }
        
        profileStackView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        choiceStackView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
        }
        
        choiceGroup.aChoiceView.snp.makeConstraints{
            $0.width.equalTo(choiceGroup.bChoiceView)
        }
        
        choiceGroup.completeView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(28)
        }

        topicGroup.timer.snp.makeConstraints{
            $0.top.equalTo(choiceStackView.snp.bottom).offset(43)
            $0.centerX.equalToSuperview()
        }
        
        choiceGroup.slideExplainView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.timer.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        informationStackView.snp.makeConstraints{
            $0.top.equalTo(choiceGroup.slideExplainView.snp.bottom).offset(43)
            $0.leading.equalToSuperview().offset(20)
        }
        
        etcGroup.declareButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(informationStackView)
        }
        
        chat.snp.makeConstraints{
            $0.top.equalTo(informationStackView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func initialize() {
        etcGroup.declareButton.tapPublisher
            .sink{ [weak self] _ in
                self?.delegate?.show()
            }
            .store(in: &cancellable)
    }
    
    func binding(data: HomeTopicItemViewModel) {
        if data.isVoted {
            guard let choice = data.votedChoice else { return }
            select(choice: choice)
        }
        else {
            choiceGroup.aChoiceView.fill(data.aOption)
            choiceGroup.bChoiceView.fill(data.bOption)
            toggle(isVoted: false)
        }
        
        topicGroup.titleLabel.text = data.title
        topicGroup.sideLabel.text = data.side
        topicGroup.keywordLabel.text = data.keyword
        userGroup.nicknameLabel.text = data.nickname
        chat.chatCountFrame.binding(data.chatCount)
        chat.likeCountFrame.binding(data.likeCount)
    }
    
    func binding(timer: TimerInfo) {
        topicGroup.timer.binding(data: timer)
    }
    
    func select(choice: Choice){
        choiceGroup.completeView.fill(choice: choice)
        toggle(isVoted: true)
    }
    
    private func toggle(isVoted value: Bool) {
        
        choiceGroup.completeView.isHidden = !value
        
        [choiceGroup.slideExplainView, choiceStackView].forEach{
            $0.isHidden = value
        }
        
        chat.canUserInteraction = value
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
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular14)
            return label
        }()
    }
    
    final class ChoiceGroup {
        let completeView: ChoiceCompleteView = ChoiceCompleteView()
        let aChoiceView = ChoiceView(option: .A)
        let bChoiceView = ChoiceView(option: .B)
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

