//
//  SelectionFrame.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Core

extension HomeTabView {

    final class SelectionFrame: BaseStackView {
        
        let aFrame: ChoiceFrame = ChoiceFrame(choice: .a)
        let bFrame: ChoiceFrame = ChoiceFrame(choice: .b)
        
        override func style() {
            axis = .horizontal
            spacing = 0
        }
        
        override func hierarchy() {
            addArrangedSubviews([aFrame, bFrame])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(188)
            }
            aFrame.snp.makeConstraints{
                $0.width.equalTo(bFrame)
            }
        }
    }
    
    final class ChoiceFrame: BaseView {
        
        private let choice: Choice
        
        init(choice: Choice){
            self.choice = choice
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let choiceLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white40
            label.setTypo(Pretendard.regular20)
            return label
        }()
        
        private let informationLabel: UILabel = {
            let label = UILabel()
            label.text = "10년 전 과거로 가기"
//            label.text = "냥냥냥냥냥냥냥냥\n냥냥냥냥냥냥냥냥\n냥냥냥냥냥냥냥냥"
            label.textColor = Color.white
            label.numberOfLines = 0
            label.setTypo(Pretendard.semibold20)
            return label
        }()
        
        override func style() {
            choiceLabel.text = choice.title
            informationLabel.textAlignment = choice.textAlignment
            backgroundColor = choice.backgroundColor
            layer.cornerRadius = 188/2
            layer.maskedCorners = choice.cornerRadiusPosition
        }
        
        override func hierarchy() {
            addSubviews([choiceLabel, informationLabel])
        }
        
        override func layout() {
            choiceLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview()
            }
            informationLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview()
            }
            choice == .a ? setALayout() : setBLayout()
        }
        
        private func setALayout(){
            choiceLabel.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(14)
            }
            informationLabel.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(32)
                $0.trailing.equalTo(choiceLabel.snp.leading).offset(-36)
            }
        }
        
        private func setBLayout(){
            choiceLabel.snp.makeConstraints{
                $0.leading.equalToSuperview().offset(14)
            }
            informationLabel.snp.makeConstraints{
                $0.trailing.equalToSuperview().inset(32)
                $0.leading.equalTo(choiceLabel.snp.trailing).offset(36)
            }
        }
        
        func binding(data: String) {
            
        }
    }
}
    
fileprivate extension Choice {
    
    var title: String {
        switch self {
        case .a:        return "A"
        case .b:        return "B"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .a:        return UIColor(r: 208, g: 67, b: 118)
        case .b:        return UIColor(r: 20, g: 150, b: 170)
        }
    }
    
    var cornerRadiusPosition: CACornerMask {
        switch self {
        case .a:        return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .b:        return [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .a:        return .right
        case .b:        return .left
        }
    }
}
