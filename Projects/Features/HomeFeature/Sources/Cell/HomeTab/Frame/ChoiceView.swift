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
            label.setTypo(Pretendard.black200)
            return label
        }()
        
        let contentLabel: UILabel = {
            let label = UILabel()
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
                $0.centerY.equalToSuperview().offset(20)
                $0.leading.equalToSuperview().offset(-69)
            }
        }
        
        private func setBLayout(){
            choiceLabel.snp.makeConstraints{
                $0.centerY.equalToSuperview().offset(20)
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
        case .A:        return Color.mainA
        case .B:        return Color.mainB
        }
    }
    
    var cornerRadiusPosition: CACornerMask {
        switch self {
        case .A:        return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        case .B:        return [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    var textAlignment: NSTextAlignment {
        .left
    }
}
