//
//  SideAChoiceView.swift
//  SideAFeature
//
//  Created by 박소윤 on 2024/02/06.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import SideAFeatureInterface
import Domain

extension SideATopicTableViewCell {
    
    struct ChoiceViewConfiguration {
        let isPercentageViewHidden: Bool
        let choiceLabelTypo: TypoCase
        let contentTextColor: UIColor
        let percentageViewBackgroundColor: UIColor?
        let percentageLabelTextColor: UIColor?
    }
    
    final class ChoiceView: BaseView {
        
        let option: Choice.Option
        
        init(option: Choice.Option, leadingOffset: CGFloat) {
            self.option = option
            self.leadingOffset = leadingOffset
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let leadingOffset: CGFloat
        private lazy var optionLabel: UILabel = {
            let label = UILabel()
            label.text = option.content.title
            label.textColor = option.content.color
            label.setTypo(Pretendard.black24)
            return label
        }()
        private let contentLabel: UILabel = UILabel()
        
        //after vote
        private let percentageView: UIView  = {
            let view = UIView()
            view.layer.cornerRadius = 10
            return view
        }()
        private let percentageLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.semibold14)
            return label
        }()
        
        override func style() {
            backgroundColor = Color.subNavy2
            layer.cornerRadius = 10
        }
        
        override func hierarchy() {
            addSubviews([percentageView, optionLabel, contentLabel, percentageLabel])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(40)
            }
            optionLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(leadingOffset)
            }
            contentLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(10)
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(optionLabel.snp.trailing).offset(10)
                $0.trailing.lessThanOrEqualToSuperview().inset(10)
            }
            percentageView.snp.makeConstraints{
                $0.leading.top.bottom.equalToSuperview()
                $0.width.equalTo(Device.width-40)
            }
            percentageLabel.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
            }
        }
        
        func fill(topic: SideATopicItemViewModel) {
            
            contentLabel.text = topic.content(of: option)
            percentageLabel.text = "\(topic.percentage(of: option))%"
            percentageView.snp.updateConstraints{
                $0.width.equalTo((Device.width-40) * CGFloat(topic.percentage(of: option)) / 100)
            }
            
            let configuration = configuration()
            
            [percentageView, percentageLabel].forEach{
                $0.isHidden = configuration.isPercentageViewHidden
            }
            contentLabel.setTypo(configuration.choiceLabelTypo)
            contentLabel.textColor = configuration.contentTextColor
            percentageView.backgroundColor = configuration.percentageViewBackgroundColor
            percentageLabel.textColor = configuration.percentageLabelTextColor
            
            func configuration() -> ChoiceViewConfiguration{
                switch topic.state(of: option) {
                case .none:
                    return .init(
                        isPercentageViewHidden: true,
                        choiceLabelTypo: Pretendard.regular14,
                        contentTextColor: Color.white,
                        percentageViewBackgroundColor: nil,
                        percentageLabelTextColor: nil
                    )
                case .select:
                    return .init(
                        isPercentageViewHidden: false,
                        choiceLabelTypo: Pretendard.semibold14,
                        contentTextColor: Color.white,
                        percentageViewBackgroundColor: Color.subPurple,
                        percentageLabelTextColor: Color.white
                    )
                case .unselect:
                    return .init(
                        isPercentageViewHidden: false,
                        choiceLabelTypo: Pretendard.semibold14,
                        contentTextColor: Color.white40,
                        percentageViewBackgroundColor: Color.subPurple.withAlphaComponent(0.3),
                        percentageLabelTextColor: Color.white40
                    )
                }
            }
        }
    }
}
