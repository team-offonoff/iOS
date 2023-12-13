//
//  ChoiceView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Domain

extension HomeTopicCollectionViewCell {
    
    class ChoiceView: BaseView {
        
        private let option: ChoiceTemp.Option
        
        init(option: ChoiceTemp.Option) {
            self.option = option
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private var content: ChoiceContent?
        
        private lazy var gradientLayer: CAGradientLayer = {
            let layer0 = option.content.gradientLayer
            layer0.position = center
            return layer0
        }()
        
        private let optionLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Color.white20
            label.setTypo(Pretendard.black200)
            return label
        }()
        
        override func style() {
            layer.cornerRadius = 148/2
            layer.maskedCorners = option.content.corenrMask
            layer.masksToBounds = true
        }
        
        override func hierarchy() {
            addSubviews([optionLabel])
        }
        
        override func layout() {
            
            self.snp.makeConstraints{
                $0.width.equalTo(Device.width-55)
                $0.height.equalTo(148)
            }

            setGradient()
            setOptionLabelLayout()
            
            func setGradient() {
                gradientLayer.frame = CGRect(
                    x: 0, y: 0,
                    width: Device.width-55, height: 148
                )
                layer.addSublayer(gradientLayer)
                bringSubviewToFront(optionLabel)
            }
            
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
            optionLabel.text = option.content.title
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
