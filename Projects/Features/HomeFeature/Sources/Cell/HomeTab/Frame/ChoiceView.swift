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
import Domain

extension HomeTopicCollectionViewCell {
    
    class ChoiceView: BaseView {
        
        private let option: ChoiceOption
        
        init(option: ChoiceOption) {
            self.option = option
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private var content: ChoiceContent?
        
        private let optionLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Color.white20
            label.setTypo(Pretendard.black200)
            return label
        }()
        
        override func style() {
            backgroundColor = option.backgroundColor
            layer.cornerRadius = 148/2
            layer.maskedCorners = option.cornerRadiusPosition
            layer.masksToBounds = true
        }
        
        override func hierarchy() {
            addSubviews([optionLabel])
        }
        
        override func layout() {
            
            self.snp.makeConstraints{
                $0.width.equalTo(UIScreen.main.bounds.size.width-55)
                $0.height.equalTo(148)
            }
            
            setOptionLabelLayout()
            
            func setOptionLabelLayout() {
                switch option {
                case .A:
                    optionLabel.snp.makeConstraints{
                        $0.centerY.equalToSuperview().offset(20)
                        $0.leading.equalToSuperview().offset(71)
                        $0.trailing.equalToSuperview().offset(-95)
                    }
                case .B:
                    optionLabel.snp.makeConstraints{
                        $0.centerY.equalToSuperview().offset(20)
                        $0.leading.equalToSuperview().offset(107)
                        $0.trailing.equalToSuperview().offset(-83)
                    }
                }
            }
        }
        
        override func initialize() {
            optionLabel.text = option.title
        }
        
        func fill(_ choice: Choice) {
            
            content = {
                if choice.content.imageURL == nil {
                    return TextChoiceContent(choice: choice)
                }
                else {
                    return ImageChoiceContent(choice: choice)
                }
            }()
            
            setContentLayout()
            
            func setContentLayout(){
                
                guard let content = content else { return }
                addSubviews(content.views)
                
                switch option {
                case .A:
                    content.setALayout()
                case .B:
                    content.setBLayout()
                }
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
