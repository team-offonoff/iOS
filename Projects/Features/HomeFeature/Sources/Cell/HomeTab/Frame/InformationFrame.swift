//
//  TopicFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

extension HomeTopicCollectionViewCell {
    
    //MARK: - Topic
    
    final class InformationFrame: BaseView {
        
        private let timerHeight = 37
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.textColor = Color.white
            label.setTypo(Pretendard.semibold24)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        lazy var willNotShowButton: UIButton = {
            let attributedString = NSMutableAttributedString(string: "이런 토픽은 안볼래요")
            attributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: Typo.font(family: .pretendard, type: .regular, size: 13),
                .foregroundColor: Color.white40,
                .underlineColor: Color.white40
            ] ,range: NSRange(location: 0, length: attributedString.length)
            )
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString(attributedString)
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            return UIButton(configuration: configuration)
        }()
        
        let timer: TimerTag = TimerTag()
        
        override func hierarchy() {
            addSubviews([titleLabel, willNotShowButton, timer])
        }
        
        override func layout() {
            titleLabel.snp.makeConstraints{
                $0.top.equalToSuperview()
                $0.height.equalTo(68)
                $0.centerX.equalToSuperview()
                $0.leading.equalToSuperview().offset(102)
            }
            willNotShowButton.snp.makeConstraints{
                $0.top.equalTo(titleLabel.snp.bottom).offset(4)
                $0.centerX.equalToSuperview()
            }
            timer.snp.makeConstraints{
                $0.top.equalTo(willNotShowButton.snp.bottom).offset(37)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    class TimerTag: BaseView {
        
        private var highlightFlag: Bool = false
        
        private let height: CGFloat = 37
        
        private let stackView: UIStackView = UIStackView(axis: .horizontal, spacing: 6)
        private let hourLabel: UILabel = UILabel()
        private let minuteLabel: UILabel = UILabel()
        private let secondLabel: UILabel = UILabel()
        private let colon1Label: UILabel = UILabel()
        private let colon2Label: UILabel = UILabel()
        
        private lazy var textLabels: [UILabel] = [hourLabel, colon1Label, minuteLabel,  colon2Label, secondLabel]
        
        override func style() {
            layer.cornerRadius = height/2
            setColorDefault()
            setText()
            setLabelsFont()
        }
        
        private func setText(){
            [colon1Label, colon2Label].forEach{
                $0.text = ":"
            }
            [hourLabel, minuteLabel, secondLabel].forEach{
                $0.text = "00"
            }
        }
        
        private func setLabelsFont(){
            textLabels.forEach{
                $0.setTypo(Typo.font(family: .monteserrat, type: .bold, size: 15))
            }
        }
        
        override func hierarchy() {
            addSubview(stackView)
            stackView.addArrangedSubviews(textLabels)
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(height)
            }
            stackView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(15)
            }
        }
        
        func binding(data: Any){
            let shouldHightlight: Bool = true  //TODO: 남은 시간 1시간 미만 연산
            if shouldHightlight && !highlightFlag {
                defer{
                    highlightFlag = true
                }
                setColorHighlight()
            }
            hourLabel.text = "00"
            minuteLabel.text = "00"
            secondLabel.text = "00"
        }
        
        private func setColorDefault(){
            backgroundColor = Color.subNavy2
            setTimeTextColor(Color.white40)
        }
        
        private func setColorHighlight(){
            backgroundColor = Color.subPurple
            setTimeTextColor(Color.subNavy2)
        }
        
        private func setTimeTextColor(_ color: UIColor){
            textLabels.forEach{
                $0.textColor = color
            }
        }
    }
}
