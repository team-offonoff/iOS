//
//  ChoiceView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Core

extension HomeTopicCollectionViewCell {

    final class ChoiceView: BaseView {
        
        private let choice: ChoiceOption
        
        init(choice: ChoiceOption){
            self.choice = choice
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let choiceLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white20
            label.setTypo(Typo.font(family: .pretendard, type: .bold, size: 200))
            return label
        }()
        
        let contentLabel: UILabel = {
            let label = UILabel()
            label.text = "10년 전 과거로 돌아가기"
            label.setTypo(Pretendard.semibold20)
            label.textColor = Color.white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        override func style() {
            choiceLabel.text = choice.title
            contentLabel.textAlignment = choice.textAlignment
            backgroundColor = choice.backgroundColor
            layer.cornerRadius = 148/2
            layer.maskedCorners = choice.cornerRadiusPosition
            layer.masksToBounds = true
        }
        
        override func hierarchy() {
            addSubviews([choiceLabel, contentLabel])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.height.equalTo(148)
            }
            contentLabel.snp.makeConstraints{
                $0.centerY.centerX.equalToSuperview()
                $0.leading.equalToSuperview().inset(44)
            }
            choice == .A ? setALayout() : setBLayout()
        }
        
        private func setALayout(){
            choiceLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(-23)
                $0.leading.equalToSuperview().offset(-69)
            }
        }
        
        private func setBLayout(){
            choiceLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(-23)
                $0.trailing.equalToSuperview().offset(57)
            }
        }
    }
}
    
fileprivate extension ChoiceOption {
    
    var title: String {
        switch self {
        case .A:        return "A"
        case .B:        return "B"
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .A:        return UIColor(r: 208, g: 67, b: 118)
        case .B:        return UIColor(r: 20, g: 150, b: 170)
        }
    }
    
    var cornerRadiusPosition: CACornerMask {
        switch self {
        case .A:        return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .B:        return [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .A:        return .left
        case .B:        return .left
        }
    }
}
