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
    
    @Published var side: Choice.Option = .A
    @Published var sideChangeViewState: SideChangeViewState = .close
    private var cancellable: Set<AnyCancellable> = []
    
    lazy var popButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.arrowLeft, for: .normal)
        return button
    }()
    
    private let titlelLabel: UILabel = {
        let label = UILabel()
        label.text = "토픽 생성"
        label.setTypo(Pretendard.semibold20)
        label.textColor = Color.white
        return label
    }()
    
    private let sideChangeButton: UIButton = {

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
            .sink{
                switch $0 {
                case .open:
                    self.sideChangeButton.configuration?.image = Image.topicGenerateHeaderArrowUp
                case .close:
                    self.sideChangeButton.configuration?.image = Image.topicGenerateHeaderArrowDown
                }
            }
            .store(in: &cancellable)
        
        $side
            .sink{ side in
                
                self.sideChangeButton.configuration?.background.backgroundColor = side.content.color.withAlphaComponent(0.2)
                self.sideChangeButton.configuration?.attributedTitle = attributedTitle()
                self.sideChangeButton.configuration?.attributedTitle?.foregroundColor = side.content.color
                
                func attributedTitle() -> AttributedString {
                    var attributedTitle = NSMutableAttributedString(string: "\(side.content.title) 사이드")
                    attributedTitle.addAttributes([.font: Pretendard.medium15.font, .foregroundColor: side.content.color], range: NSRange(location: 0, length: attributedTitle.length))
                    return AttributedString(attributedTitle)
                    
                }
            }
            .store(in: &cancellable)
    }
    
}
