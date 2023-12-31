//
//  ImageContentView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/31.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import Domain

extension TopicContentInputTableViewCell {
    
    class ImageContentView: BaseView, ImageTextIncludeContentView {
        
        var aTextPublisher: AnyPublisher<String, Never> {
            aTextField.textField.publisher(for: .editingDidEnd)
        }
        var bTextPublisher: AnyPublisher<String, Never> {
            bTextField.textField.publisher(for: .editingDidEnd)
        }
        var aImagePublisher: AnyPublisher<UIImage?, Never>? {
            aImageSubject.eraseToAnyPublisher()
        }
        var bImagePublisher: AnyPublisher<UIImage?, Never>? {
            bImageSubject.eraseToAnyPublisher()
        }
        
        let aImageSubject: CurrentValueSubject<UIImage?, Never> = CurrentValueSubject<UIImage?, Never>(nil)
        let bImageSubject: CurrentValueSubject<UIImage?, Never> = CurrentValueSubject<UIImage?, Never>(nil)
        
        private let commentLabel: UILabel = {
           let label = UILabel()
            label.text = "가로 세로 길이가 같은 사진을 올리는 것이 좋아요.\n너무 큰 용량의 사진은 화질이 조정될 수 있어요."
            label.textColor = Color.white40
            label.setTypo(Pretendard.regular13, setLineSpacing: true)
            label.numberOfLines = 0
            return label
        }()
        
        private let imageStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 13)
        private let switchButton: UIButton = {
           let button = UIButton()
            button.setImage(Image.topicGenerateSwitch, for: .normal)
            return button
        }()
        private let aImageView: UIImageView = CustomImageView(option: .A)
        private let bImageView: UIImageView = CustomImageView(option: .B)
        
        private let textFieldStackView: UIStackView = UIStackView(axis: .vertical, spacing: 10)
        private let aTextField = ImageContentTextField(option: .A)
        private let bTextField = ImageContentTextField(option: .B)
        
        override func hierarchy() {
            addSubviews([commentLabel, imageStackView, textFieldStackView])
            imageStackView.addArrangedSubviews([aImageView, bImageView])
            imageStackView.addSubview(switchButton)
            textFieldStackView.addArrangedSubviews([aTextField, bTextField])
        }
        
        override func layout() {
            commentLabel.snp.makeConstraints{
                $0.top.leading.equalToSuperview()
            }
            imageStackView.snp.makeConstraints{
                $0.top.equalTo(commentLabel.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
            }
            switchButton.snp.makeConstraints{
                $0.center.equalToSuperview()
            }
            textFieldStackView.snp.makeConstraints{
                $0.top.equalTo(imageStackView.snp.bottom).offset(30)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        
        func text(option: Choice.Option) -> String {
            switch option {
            case .A:    return aTextField.textField.text ?? ""
            case .B:    return bTextField.textField.text ?? ""
            }
        }
        
        func image(option: Choice.Option) -> UIImage? {
            switch option {
            case .A:    return aImageSubject.value
            case .B:    return bImageSubject.value
            }
        }
        
        class CustomImageView: UIImageView {
            
            init(option: Choice.Option) {
                self.option = option
                super.init(frame: .zero)
                style()
                hierarchy()
                layout()
                initialize()
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private let option: Choice.Option
            private let uploadLabel: UILabel = {
                let label = UILabel()
                label.text = "업로드"
                label.textColor = Color.subPurple
                label.setTypo(Pretendard.semibold14)
                return label
            }()
            private let optionLabel: UILabel = {
                let label = UILabel()
                label.setTypo(Pretendard.black100)
                return label
            }()
            private let cancelButton: UIButton = {
                let button = UIButton()
                button.setImage(Image.topicGenerateImageCancel, for: .normal)
                button.snp.makeConstraints{
                    $0.width.height.equalTo(18)
                }
                return button
            }()
            
            private func style() {
                layer.cornerRadius = 10
                layer.masksToBounds = true
                backgroundColor = Color.subNavy2.withAlphaComponent(0.8)
            }
            
            private func hierarchy() {
                addSubviews([uploadLabel, optionLabel, cancelButton])
            }
            
            private func layout() {
                self.snp.makeConstraints{
                    $0.width.height.equalTo(90)
                }
                uploadLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(8)
                    $0.centerX.equalToSuperview()
                }
                optionLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(12)
                    $0.centerX.equalToSuperview()
                }
                cancelButton.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(8)
                    $0.centerX.equalToSuperview()
                }
            }
            
            private func initialize() {
                optionLabel.text = option.content.title
                optionLabel.textColor = option.content.color.withAlphaComponent(0.4)
            }
        }
        
        class ImageContentTextField: CustomTextFieldView{
            
            init(option: Choice.Option) {
                super.init(placeholder: "이미지를 간단히 설명해주세요", insets: UIEdgeInsets(top: 16, left: 35, bottom: 16, right: 40), isErrorNeed: false)
                optionLabel.text = option.rawValue
                optionLabel.textColor = option.content.color
            }
            
            required init(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private lazy var optionLabel: UILabel = {
               let label = UILabel()
                label.setTypo(Pretendard.semibold14)
                addSubview(label)
                label.snp.makeConstraints{
                    $0.centerY.equalToSuperview()
                    $0.leading.equalToSuperview().offset(16)
                }
                return label
            }()
            
            override func style() {
                super.style()
                textField.backgroundColor = Color.subNavy2.withAlphaComponent(0.4)
                textField.textColor = Color.white
                customPlaceholder(color: Color.subPurple.withAlphaComponent(0.6), font: Pretendard.medium16.font)
            }
        }
    }
}
