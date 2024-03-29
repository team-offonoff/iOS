//
//  TopicDetailCollectionViewCell.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/08.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import Domain
import TopicFeatureInterface
import FeatureDependency
import Core
import Combine

open class TopicDetailCollectionViewCell: BaseCollectionViewCell{
    
    public weak var delegate: (VoteDelegate & TopicBottomSheetDelegate & ChatBottomSheetDelegate)?
    
    public let topicGroup: TopicGroup = TopicGroup()
    public let userGroup: UserGroup = UserGroup()
    public let choiceGroup: ChoiceGroup = ChoiceGroup()
    public let etcGroup: EtcGroup = EtcGroup()
    public let chat: CommentView = CommentView()
    
    public let profileStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 8)
    public let choiceStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 15)
    public let informationStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 7)
    
    // 스와이프 제스처 관련 프로퍼티
    private enum SwipeState {
        case choiceA
        case choiceB
        case normal
    }
    private var state: SwipeState = .normal
    private var originalPoint: CGPoint = CGPoint()
    
    private var cancellable: Set<AnyCancellable> = []
    
    public override func prepareForReuse() {
        choiceGroup.aChoiceView.removeContent()
        choiceGroup.bChoiceView.removeContent()
    }
    
    public override func style() {
        clipsToBounds = true
    }
    
    public override func hierarchy() {

        baseView.addSubviews([etcGroup.titleLabel, topicGroup.titleLabel, profileStackView, choiceGroup.swipeableView, choiceGroup.completeView, choiceGroup.voteResultView, topicGroup.timer, choiceGroup.slideExplainView, informationStackView, etcGroup.etcButton, chat])
        
        choiceGroup.swipeableView.addSubviews([choiceStackView])
        
        profileStackView.addArrangedSubviews([userGroup.profileImageView, userGroup.nicknameLabel])
        
        choiceStackView.addArrangedSubviews([choiceGroup.aChoiceView, choiceGroup.bChoiceView])

        informationStackView.addArrangedSubviews([topicGroup.sideLabel, etcGroup.separatorLine, topicGroup.keywordLabel])
    }
    
    open override func layout() {
        
        etcGroup.titleLabel.snp.makeConstraints{
            $0.top.centerX.equalToSuperview()
        }
        
        topicGroup.titleLabel.snp.makeConstraints{
            $0.top.equalTo(etcGroup.titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(102)
        }
        
        profileStackView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        choiceGroup.swipeableView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview()
        }
        
        choiceStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(36)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        choiceGroup.aChoiceView.snp.makeConstraints{
            $0.width.equalTo(choiceGroup.bChoiceView)
        }
        
        choiceGroup.completeView.snp.makeConstraints{
            $0.top.equalTo(profileStackView.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(28)
        }
        
        choiceGroup.voteResultView.snp.makeConstraints{
            $0.top.equalTo(topicGroup.titleLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
        }

        topicGroup.timer.snp.makeConstraints{
            $0.top.equalTo(choiceGroup.swipeableView.snp.bottom).offset(7)
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
        
        etcGroup.etcButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(informationStackView)
        }
        
        chat.snp.makeConstraints{
            $0.top.equalTo(informationStackView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    public override func initialize() {

        addTarget()
        addTapGesture()
        addPanGesture()
        
        func addTarget(){
            etcGroup.etcButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.delegate?.show(DelegateSender(identifier: Topic.Action.showBottomSheet.identifier))
                }
                .store(in: &cancellable)
        }
        
        func addTapGesture() {
            chat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatTapGesture)))
        }
        
        func addPanGesture() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
            panGesture.delaysTouchesBegan = false
            panGesture.delaysTouchesEnded = false
            choiceGroup.swipeableView.addGestureRecognizer(panGesture)
        }
    }
    
    @objc private func chatTapGesture(_ recognizer: UITapGestureRecognizer) {
        delegate?.show(DelegateSender(identifier: Comment.Action.showBottomSheet.identifier))
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: choiceStackView)
        
        switch recognizer.state {
            
        case .began:
            
            initializeState()
            
            func initializeState() {
                state = .normal
                originalPoint = choiceStackView.frame.origin
            }
            
        case .changed:
            
            moveChoiceView()
            changeState()
            
            func moveChoiceView() {
                choiceStackView.frame.origin = CGPoint(x: originalPoint.x + translation.x, y: originalPoint.y)
            }
            
            func changeState() {
                if abs(translation.x) >= Device.width/2 {
                    if state == .normal && translation.x <= 0{
                        state = .choiceB
                    }
                    else if state == .normal && translation.x >= 0{
                        state = .choiceA
                    }
                }
            }
        case .ended:
            
            let (option, movePoint): (Choice.Option?, CGPoint) = {
                switch state {
                case .normal:
                    return (nil, originalPoint)
                case .choiceA:
                    return (.A, CGPoint(x: 0, y: originalPoint.y))
                case .choiceB:
                    return (.B, CGPoint(x: -(ChoiceView.width+ChoiceView.visibleWidth+ChoiceView.extraWidth+ChoiceView.spacing), y: originalPoint.y))
                }
            }()
            
            startVoteAnimate()
            startFadeAnimation()
            
            func startVoteAnimate() {
                UIView.animate(
                    withDuration: 0.4,
                    animations: {
                        self.choiceStackView.frame.origin = movePoint
                    }
                )
            }
            
            func startFadeAnimation() {
                // option 값이 nil인 경우(normal 상태), fade 애니메이션을 진행하지 않는다
                guard let option = option else { return }
                UIView.animate(
                    withDuration: 0.6,
                    delay: 0.3,
                    animations: {
                        self.choiceStackView.alpha = 0
                    },
                    completion: { [weak self] _ in
                        guard let self = self else { return }
                        initializeChoiceView()
                        self.delegate?.vote(option, index: self.cellIndexPath?.row)
                    }
                )
                
                func initializeChoiceView() {
                    choiceStackView.isHidden = true
                    choiceStackView.frame.origin = originalPoint
                    choiceStackView.alpha = 1
                }
            }
    
        default:
            return
        }
    }
    
    public func binding(timer: TimerInfo) {
        topicGroup.timer.binding(data: timer)
    }
    
    open func binding(data: TopicDetailItemViewModel, comment: Comment?) {
        if data.isVoted {
            guard let votedOption = data.votedOption, let votedChoice = data.choices[votedOption] else { return }
            select(choice: votedChoice)
        }
        else {
            toggle(isVoted: false)
        }
        
        choiceGroup.aChoiceView.fill(data.choices[.A]!)
        choiceGroup.bChoiceView.fill(data.choices[.B]!)
        choiceGroup.voteResultView.fill(data)
        topicGroup.titleLabel.text = data.title
        topicGroup.sideLabel.text = data.side
        topicGroup.keywordLabel.text = data.keyword
        userGroup.nicknameLabel.text = data.nickname
        chat.chatCountFrame.binding(data.commentCount)
        chat.likeCountFrame.binding(data.voteCount)
        
        data.isCommentEmpty ? chat.empty(isVoted: data.isVoted) : chat.fill(comment: comment, isVoted: data.isVoted)
    }
}

//MARK: Input

extension TopicDetailCollectionViewCell {
    
    public func select(choice: Choice){
        choiceGroup.completeView.fill(choice: choice)
        toggle(isVoted: true)
    }
    
    public func clearVote() {
        toggle(isVoted: false)
    }
    
    private func toggle(isVoted value: Bool) {
        choiceGroup.completeView.isHidden = !value
        [choiceGroup.slideExplainView, choiceStackView].forEach{
            $0.isHidden = value
        }
    }
    
    public func failVote() {
        choiceStackView.isHidden = false
    }
}

//MARK: Output

extension TopicDetailCollectionViewCell {
    public func standardOfCommentBottomSheetNormalState() -> UIView{
        profileStackView
    }
}

//MARK: UI

extension TopicDetailCollectionViewCell {
    
    public final class TopicGroup {
        public let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 2
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold24, setLineSpacing: true)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.snp.makeConstraints{
                $0.height.equalTo(68)
            }
            return label
        }()
        public let timer: TimerView = TimerView()
        public let sideLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular13)
            label.textColor = Color.subPurple
            return label
        }()
        public let keywordLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.regular13)
            label.textColor = Color.white60
            return label
        }()
    }
    
    public final class UserGroup {
        public let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(85)
            imageView.layer.cornerRadius = 22/2
            imageView.layer.masksToBounds = true
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return imageView
        }()
        public let nicknameLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white60
            label.setTypo(Pretendard.regular14)
            return label
        }()
    }
    
    public final class ChoiceGroup {
        public let swipeableView: UIView = UIView()
        public let completeView: ChoiceCompleteView = ChoiceCompleteView()
        public let aChoiceView = ChoiceView(option: .A)
        public let bChoiceView = ChoiceView(option: .B)
        public let voteResultView = VoteResultView()
        public lazy var slideExplainView: UIView = {
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
    
    public final class EtcGroup {
        public let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "실시간 인기 토픽"
            label.setTypo(Pretendard.regular18)
            label.textColor = Color.subPurple
            return label
        }()
        public let separatorLine: UIView = {
            let view = UIView()
            view.backgroundColor = Color.white20
            view.snp.makeConstraints{
                $0.width.equalTo(1)
                $0.height.equalTo(12)
            }
            return view
        }()
        public let etcButton: UIButton = {
            let button = UIButton()
            button.setImage(Image.more, for: .normal)
            button.snp.makeConstraints{
                $0.width.height.equalTo(22)
            }
            return button
        }()
    }
}
