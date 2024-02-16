//
//  TimerView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/11/28.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

extension TopicDetailCollectionViewCell {
    
    public class TimerView: BaseView {
        
        private var highlightFlag: Bool = false
        
        private let height: CGFloat = 30
        
        private let stackView: UIStackView = UIStackView(axis: .horizontal, spacing: 6)
        private let hourLabel: UILabel = UILabel()
        private let minuteLabel: UILabel = UILabel()
        private let secondLabel: UILabel = UILabel()
        private let colon1Label: UILabel = UILabel()
        private let colon2Label: UILabel = UILabel()
        
        private lazy var textLabels: [UILabel] = [hourLabel, colon1Label, minuteLabel,  colon2Label, secondLabel]
        
        public override func style() {
            layer.cornerRadius = height/2
            setColorDefault()
            setText()
            setLabelsFont()
            setLabelTextColor()
            
            func setText(){
                [colon1Label, colon2Label].forEach{
                    $0.text = ":"
                }
                [hourLabel, minuteLabel, secondLabel].forEach{
                    $0.text = "00"
                }
            }
            
            func setLabelsFont(){
                textLabels.forEach{
                    $0.setTypo(Typo.font(family: .monteserrat, type: .medium, size: 16))
                }
            }
            
            func setLabelTextColor(){
                textLabels.forEach{
                    $0.textColor = Color.white80
                }
            }
        }
        
        public override func hierarchy() {
            addSubview(stackView)
            stackView.addArrangedSubviews(textLabels)
        }
        
        public override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(height)
            }
            stackView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(4)
                $0.leading.trailing.equalToSuperview().inset(12)
            }
        }
        
        func binding(data: TimerInfo){
            if data.isHighlight && !highlightFlag {
                defer{
                    highlightFlag = true
                }
                setColorHighlight()
            }
            hourLabel.text = data.time.hour.doubleDigitFormat
            minuteLabel.text = data.time.minute.doubleDigitFormat
            secondLabel.text = data.time.second.doubleDigitFormat
        }
        
        private func setColorDefault(){
            backgroundColor = Color.subNavy2
        }
        
        private func setColorHighlight(){
            backgroundColor = Color.subPurple
        }
    }
}
