//
//  TopicSideChoiceView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain
import Combine

protocol TopicSideChoiceViewConfiguration {
    var isSideSelected: Bool { get }
    var isAViewHidden: Bool { get }
    var isBViewHidden: Bool { get }
    var ctaButtonBackgroundColor: UIColor? { get }
    var sideExplain: String? { get }
}

final class TopicSideChoiceView: BaseView {
    
    @Published var state: Topic.Side?
    private var cancellable: Set<AnyCancellable> = []
    
    //MARK: UI
    
    private let choiceGuideStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: 2)
        stackView.alignment = .center
        return stackView
    }()
    private let sideChoiceGuideLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.semibold14, setLineSpacing: true)
        label.text = "A/B 사이드\n눌러서 선택하기"
        label.textColor = Color.subPurple
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let guideIconImageView: UIImageView = {
        let image = UIImageView(image: Image.topicGenerateArrowDown)
        image.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
        return image
    }()
    
    let sideChoice: SideChoice = SideChoice()
    private let whichSideGenerateLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.semibold24, setLineSpacing: true)
        label.text = "어떤 토픽을\n만들어 볼까요?"
        label.textColor = Color.white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    private let sideExplainLabel: UILabel = {
        let label = UILabel()
        label.setTypo(Pretendard.regular15, setLineSpacing: true)
        label.text = "가벼운 주제부터 무거운 고민까지\n세상의 모든 토픽을 담아요"
        label.textColor = Color.white60
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    let ctaButton: UIButton = {
        var attributedString = NSMutableAttributedString(string: "토픽 만들기")
        attributedString.addAttributes([.font: Pretendard.bold18.font, .foregroundColor: Color.white], range: NSRange(location: 0, length: attributedString.length))
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString(attributedString)
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 76, bottom: 13, trailing: 77)
        return UIButton(configuration: configuration)
    }()
    private let bottomImage: UIImageView = UIImageView(image: Image.topicGenerateBottom)
    
    override func hierarchy() {
        choiceGuideStackView.addArrangedSubviews([sideChoiceGuideLabel, guideIconImageView])
        addSubviews([bottomImage, choiceGuideStackView, sideChoice.noramlView, sideChoice.aView, sideChoice.bView, whichSideGenerateLabel, sideExplainLabel, ctaButton])
    }
    
    override func layout() {
        choiceGuideStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(19)
            $0.centerX.equalToSuperview()
        }
        sideChoice.noramlView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(108)
            $0.centerX.equalToSuperview()
        }
        
        sideChoice.aView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(83)
            $0.centerX.equalToSuperview()
        }
        
        sideChoice.bView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(86)
            $0.centerX.equalToSuperview()
        }
        
        whichSideGenerateLabel.snp.makeConstraints{
            $0.top.equalTo(sideChoice.noramlView.snp.bottom).inset(20)
            $0.centerX.equalToSuperview()
        }
        sideExplainLabel.snp.makeConstraints{
            $0.top.equalTo(sideChoice.aView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        ctaButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(60)
        }
        bottomImage.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize() {
        $state
            .sink{ [weak self] state in
                
                guard let self = self else { return }
                
                let configuration = configuration()
                
                [self.choiceGuideStackView, self.sideChoice.noramlView, self.whichSideGenerateLabel].forEach{
                    $0.isHidden = configuration.isSideSelected
                }
                
                [self.ctaButton, self.sideExplainLabel].forEach{
                    $0.isHidden = !configuration.isSideSelected
                }
                
                self.sideChoice.aView.isHidden = configuration.isAViewHidden
                self.sideChoice.bView.isHidden = configuration.isBViewHidden
                
                self.ctaButton.configuration?.background.backgroundColor = configuration.ctaButtonBackgroundColor
                
                
                func configuration() -> TopicSideChoiceViewConfiguration {
                    switch state {
                    case .A:    return ChoiceTopicSideAConfiguration()
                    case .B:    return ChoiceTopicSideBConfiguration()
                    default:    return TopicSideDeselectConfiguration()
                    }
                }
            }
            .store(in: &cancellable)
    }
}

extension TopicSideChoiceView {
    class SideChoice {
        let noramlView: UIImageView = UIImageView(image: Image.topicGenerateNormal)
        let aView: UIImageView = UIImageView(image: Image.topicGenerateChoiceA)
        let bView: UIImageView = UIImageView(image: Image.topicGenerateChoiceB)
    }
}

fileprivate struct TopicSideDeselectConfiguration: TopicSideChoiceViewConfiguration {
    let isSideSelected: Bool = false
    let isAViewHidden: Bool = true
    let isBViewHidden: Bool = true
    let ctaButtonBackgroundColor: UIColor? = nil
    let sideExplain: String? = nil
}

fileprivate struct ChoiceTopicSideAConfiguration: TopicSideChoiceViewConfiguration {
    let isSideSelected: Bool = true
    let isAViewHidden: Bool = false
    let isBViewHidden: Bool = true
    let ctaButtonBackgroundColor: UIColor? = Color.mainA
    let sideExplain: String? = "가벼운 주제부터 무거운 고민까지\n세상의 모든 토픽을 담아요"
}

fileprivate struct ChoiceTopicSideBConfiguration: TopicSideChoiceViewConfiguration {
    let isSideSelected: Bool = true
    let isAViewHidden: Bool = true
    let isBViewHidden: Bool = false
    let ctaButtonBackgroundColor: UIColor? = Color.mainB
    let sideExplain: String? = "카피라이팅, A/B Test 등 다양한\n직무의 고민과 토픽을 담아요"
}
