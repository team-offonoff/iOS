//
//  TopicGenerateHeaderView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/29.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain
import Combine

final class TopicGenerateHeaderView: BaseHeaderView, Navigatable {
    
    enum SideChangeViewState {
        case open
        case close
    }
    
    var topicSide: CurrentValueSubject<Topic.Side, Never>? {
        didSet {
            bindTopicSide()
            updateSideButtonConfiguration()
        }
    }

    @Published var sideChangeViewState: SideChangeViewState = .close
    private var cancellable: Set<AnyCancellable> = []
    
    lazy var popButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.back, for: .normal)
        return button
    }()
    
    private let titlelLabel: UILabel = {
        let label = UILabel()
        label.text = "토픽 생성"
        label.setTypo(Pretendard.semibold20)
        label.textColor = Color.white
        return label
    }()
    
    let sideChangeButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 3
        configuration.imagePlacement = .trailing
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        return UIButton(configuration: configuration)
    }()
    
    override func hierarchy() {
        addSubviews([popButton, titlelLabel, sideChangeButton])
    }
    
    override func layout() {
        popButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
        }
        titlelLabel.snp.makeConstraints{
            $0.leading.equalTo(popButton.snp.trailing).offset(57.5)
            $0.centerY.equalToSuperview()
        }
        sideChangeButton.snp.makeConstraints{
            $0.leading.equalTo(titlelLabel.snp.trailing).offset(8)
            $0.centerY.equalToSuperview().offset(1)
        }
    }
    
    override func initialize() {
        updateConfiguration()
    }
    
    private func updateConfiguration()  {
        
        $sideChangeViewState
            .sink{ [weak self] in
                switch $0 {
                case .open:
                    self?.sideChangeButton.configuration?.image = Image.topicGenerateHeaderArrowUp.withTintColor(self?.topicSide?.value.content.color ?? .white)
                case .close:
                    self?.sideChangeButton.configuration?.image = Image.topicGenerateHeaderArrowDown.withTintColor(self?.topicSide?.value.content.color ?? .white)
                }
            }
            .store(in: &cancellable)
    }
    
    private func bindTopicSide() {
        topicSide?
            .sink{ [weak self] side in
                self?.updateSideButtonConfiguration()
            }
            .store(in: &cancellable)
    }
    
    private func updateSideButtonConfiguration() {
        
        guard let topicSide = topicSide?.value else { return }
        
        self.sideChangeButton.configuration?.background.backgroundColor = topicSide.content.color.withAlphaComponent(0.2)
        self.sideChangeButton.configuration?.attributedTitle = attributedTitle()
        self.sideChangeButton.configuration?.attributedTitle?.foregroundColor = topicSide.content.color
        self.sideChangeButton.configuration?.image = self.sideChangeButton.configuration?.image?.withTintColor(topicSide.content.color)
        
        func attributedTitle() -> AttributedString {
            let attributedTitle = NSMutableAttributedString(string: "\(topicSide.content.title) 사이드")
            attributedTitle.addAttributes([.font: Pretendard.medium15.font, .foregroundColor: topicSide.content.color], range: NSRange(location: 0, length: attributedTitle.length))
            return AttributedString(attributedTitle)
        }
    }
    
}
