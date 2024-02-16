//
//  ChoiceView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Domain

extension TopicDetailCollectionViewCell {
    
    public class ChoiceView: BaseView {
        
        static let spacing: CGFloat = 15
        static let extraWidth: CGFloat = 100
        static let unvisibleWidth: CGFloat = Device.width + extraWidth
        static let visibleWidth: CGFloat = (Device.width-15)/2
        static let width: CGFloat = unvisibleWidth + visibleWidth
        
        private let option: Choice.Option
        
        init(option: Choice.Option) {
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
        
        public override func style() {
            layer.cornerRadius = 148/2
            layer.maskedCorners = option.content.corenrMask
            layer.masksToBounds = true
        }
        
        public override func hierarchy() {
            addSubviews([optionLabel])
        }
        
        public override func layout() {
            
            self.snp.makeConstraints{
                $0.width.equalTo(ChoiceView.width)
                $0.height.equalTo(148)
            }

            setGradient()
            setOptionLabelLayout()
            
            func setGradient() {
                gradientLayer.frame = CGRect(
                    x: 0, y: 0,
                    width: ChoiceView.width, height: 148
                )
                layer.addSublayer(gradientLayer)
                bringSubviewToFront(optionLabel)
            }
            
            func setOptionLabelLayout() {
                switch option {
                case .A:
                    optionLabel.snp.makeConstraints{
                        $0.centerY.equalToSuperview().offset(20)
                        $0.trailing.equalToSuperview().inset((Device.width-15)/2-85)
                    }
                case .B:
                    optionLabel.snp.makeConstraints{
                        $0.centerY.equalToSuperview().offset(20)
                        $0.leading.equalToSuperview().offset((Device.width-15)/2-77)
                    }
                }
            }
        }
        
        public override func initialize() {
            optionLabel.text = option.content.title
        }
        
        func removeContent() {
            content = nil
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
