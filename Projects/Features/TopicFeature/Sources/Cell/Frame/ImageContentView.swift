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
        private let aImageView: CustomImageView = CustomImageView(option: .A)
        private let bImageView: CustomImageView = CustomImageView(option: .B)
        
        private let textFieldStackView: UIStackView = UIStackView(axis: .vertical, spacing: 10)
        private let aTextField = ImageContentTextField(option: .A)
        private let bTextField = ImageContentTextField(option: .B)
        
        private var cancellable: Set<AnyCancellable> = []
        
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
        
        override func initialize() {
            
            addTarget()
            addGestureRecognizer()
            
            func addTarget() {
                switchButton.tapPublisher
                    .sink{ [weak self] _ in
                        
                        guard let self = self else { return }
                        
                        switchInput()
                        
                        func switchInput() {
                            
                            let temp: (UIImage?, String) = (self.image(option: .A), self.text(option: .A))
                            
                            self.aImageView.imageSubject.send(self.image(option: .B))
                            self.aTextField.update(text: self.text(option: .B))
                            
                            self.bImageView.imageSubject.send(temp.0)
                            self.bTextField.update(text: temp.1)
                        }
                    }
                    .store(in: &cancellable)
            }
            
            func addGestureRecognizer() {
                [aImageView, bImageView].forEach{
                    $0.isUserInteractionEnabled = true
                    $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTap)))
                }
            }
        }
        
        //토픽 생성 ViewController에서 image picker를 띄우도록 알림을 보낸다
        @objc private func imageTap(_ recognizer: UITapGestureRecognizer) {
            
            guard let view = recognizer.view as? CustomImageView else { return }
            
            NotificationCenter.default
                .post(
                    name: Notification.Name(Topic.Action.showImagePicker.identifier),
                    object: self,
                    userInfo: [Choice.Option.identifier: view.option]
                )
        }
        
        //MARK: Input
        
        func setLimitCount(_ count: Int?) {
            aTextField.limitCount = count
            bTextField.limitCount = count
        }
        
        func setImage(_ image: UIImage, option: Choice.Option) {
            switch option {
            case .A:    aImageView.imageSubject.send(image)
            case .B:    bImageView.imageSubject.send(image)
            }
        }
        
        func reset() {
            
            resetImageView()
            resetTextField()
            
            func resetImageView() {
                aImageView.imageSubject.send(nil)
                bImageView.imageSubject.send(nil)
            }
            
            func resetTextField() {
                aTextField.update(text: "")
                bTextField.update(text: "")
            }
        }
        
        //MARK: Output
        
        var aTextPublisher: AnyPublisher<String, Never> {
            aTextField.textField.publisher(for: .editingDidEnd)
        }
        var bTextPublisher: AnyPublisher<String, Never> {
            bTextField.textField.publisher(for: .editingDidEnd)
        }
        var aImagePublisher: AnyPublisher<UIImage?, Never>? {
            aImageView.imageSubject.eraseToAnyPublisher()
        }
        var bImagePublisher: AnyPublisher<UIImage?, Never>? {
            bImageView.imageSubject.eraseToAnyPublisher()
        }
        
        func text(option: Choice.Option) -> String {
            switch option {
            case .A:    return aTextField.textField.text ?? ""
            case .B:    return bTextField.textField.text ?? ""
            }
        }
        
        func image(option: Choice.Option) -> UIImage? {
            switch option {
            case .A:    return aImageView.imageSubject.value
            case .B:    return bImageView.imageSubject.value
            }
        }
    }
}

extension TopicContentInputTableViewCell {
    
    class CustomImageView: BaseView {
        
        init(option: Choice.Option) {
            self.option = option
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: Output
        
        let option: Choice.Option
        let imageSubject: CurrentValueSubject<UIImage?, Never> = CurrentValueSubject(nil)
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            return imageView
        }()
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
        private let dimView: UIView = {
            let view = UIView()
            view.backgroundColor = Color.black.withAlphaComponent(0.6)
            return view
        }()
        private var cancellable: Set<AnyCancellable> = []
        
        override func style() {
            layer.cornerRadius = 10
            layer.masksToBounds = true
            backgroundColor = Color.subNavy2.withAlphaComponent(0.8)
        }
        
        override func hierarchy() {
            addSubviews([imageView, dimView, uploadLabel, optionLabel, cancelButton])
        }
        
        override func layout() {
            self.snp.makeConstraints{
                $0.width.height.equalTo(90)
            }
            imageView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
            dimView.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
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
        
        override func initialize() {
            
            setOptionLabelStyle()
            addTarget()
            addSubscriber()
            
            func setOptionLabelStyle() {
                optionLabel.text = option.content.title
                optionLabel.textColor = option.content.color.withAlphaComponent(0.4)
            }
            
            func addTarget() {
                cancelButton.tapPublisher
                    .sink{ [weak self] _ in
                        self?.imageSubject.send(nil)
                    }
                    .store(in: &cancellable)
            }
            
            func addSubscriber() {
                imageSubject
                    .receive(on: DispatchQueue.main)
                    .sink{ [weak self] image in
                        self?.imageView.image = image
                        self?.setComponentVisibility()
                    }
                    .store(in: &cancellable)
            }
        }
        
        //MARK: Input
        
        func setComponentVisibility() {
            if imageView.image == nil {
                uploadLabel.isHidden = false
                cancelButton.isHidden = true
                dimView.isHidden = true
            }
            else {
                uploadLabel.isHidden = true
                cancelButton.isHidden = false
                dimView.isHidden = false
            }
        }
    }
}
extension TopicContentInputTableViewCell {
    
    class ImageContentTextField: ABTextFieldView{
        
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
            countLabel.textColor = Color.subPurple.withAlphaComponent(0.6)
        }
    }
}
