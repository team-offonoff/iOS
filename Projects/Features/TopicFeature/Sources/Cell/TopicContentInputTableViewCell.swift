//
//  TopicContentInputTableViewCell.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain
import Combine

final class TopicContentInputTableViewCell: BaseTableViewCell {
    
    var contentType: CurrentValueSubject<Topic.ContentType, Never>? {
        didSet {
            updateContentType()
            bind()
        }
    }

    let contentTypeChoice: ContentType = ContentType()
    private let contentSubView: SubtitleView = SubtitleView(subtitle: "토픽 내용", content: UIView())
    private let textContentView: TextContentView = TextContentView()
    private let imageContentView: ImageContentView = ImageContentView()
    private let deadlineSubView: SubtitleView = SubtitleView(subtitle: "마감 시간", content: DropDownView(placeholder: "1시간 뒤"))
    let ctaButton: CTAButton = CTAButton(title: "토픽 올리기")
    
    private var cancellable: Set<AnyCancellable> = []
    //content view의 하단 레이아웃 조정을 위한 배열
    private var contentViewBottomConstraints: [NSLayoutConstraint] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    override func hierarchy() {
        contentTypeChoice.stackView.addArrangedSubviews([contentTypeChoice.text, contentTypeChoice.image])
        baseView.addSubviews([contentTypeChoice.stackView, contentSubView, deadlineSubView, ctaButton])
        contentSubView.contentView.addSubviews([textContentView, imageContentView])
    }
    
    override func layout() {
        baseView.snp.makeConstraints{
            $0.height.equalTo(Device.height - (Device.safeAreaInsets?.top ?? 0) - 48 - 30)
        }
        contentTypeChoice.stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        contentSubView.snp.makeConstraints{
            $0.top.equalTo(contentTypeChoice.stackView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        textContentView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        imageContentView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        deadlineSubView.snp.makeConstraints{
            $0.top.equalTo(contentSubView.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        ctaButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
    
    override func initialize() {
        
        addGestureRecognizer()
        
        func addGestureRecognizer() {
            [contentTypeChoice.text, contentTypeChoice.image].forEach{
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeContentType)))
            }
        }
    }
    
    @objc func changeContentType(_ recognizer: UITapGestureRecognizer) {
        
        guard let view = recognizer.view as? ContentTypeChoiceView else { return }
        
        if contentType?.value != view.contentType {
            contentType?.send(view.contentType)
        }
    }
    
    private func bind() {
        contentType?
            .sink{ [weak self] _ in
                self?.updateContentType()
            }
            .store(in: &cancellable)
    }
    
    private func updateContentType() {
        
        deactiveExistingConstraints()
        
        switch contentType?.value {
        case .text:
            contentTypeChoice.text.isSelected = true
            contentTypeChoice.image.isSelected = false
            textContentView.isHidden = false
            imageContentView.isHidden = true
            
            contentViewBottomConstraints = [textContentView.bottomAnchor.constraint(equalTo: textContentView.superview!.bottomAnchor)]
            
        case .image:
            contentTypeChoice.image.isSelected = true
            contentTypeChoice.text.isSelected = false
            textContentView.isHidden = true
            imageContentView.isHidden = false
            
            contentViewBottomConstraints = [imageContentView.bottomAnchor.constraint(equalTo: imageContentView.superview!.bottomAnchor)]
            
        case .none:
            return
        }
        
        activateNewConstraints()
        
        func deactiveExistingConstraints() {
            NSLayoutConstraint.deactivate(contentViewBottomConstraints)
        }
        
        func activateNewConstraints() {
            NSLayoutConstraint.activate(contentViewBottomConstraints)
            contentSubView.contentView.layoutIfNeeded()
        }
    }
}

extension TopicContentInputTableViewCell {
    
    class ContentType {
        let stackView: UIStackView = {
            let stackView = UIStackView(axis: .horizontal, spacing: 8)
            stackView.alignment = .center
            return stackView
        }()
        let text: ContentTypeChoiceView = ContentTypeChoiceView(type: .text, title: "텍스트", normalIcon: Image.topicGenerateTextNoraml, selectedIcon: Image.topicGenerateTextSelected)
        let image: ContentTypeChoiceView = ContentTypeChoiceView(type: .image, title: "이미지", normalIcon: Image.topicGenerateImageNormal, selectedIcon: Image.topicGenerateTextSelected)
    }
    
    final class ContentTypeChoiceView: BaseView {
        
        init(type: Topic.ContentType, title: String, normalIcon: UIImage, selectedIcon: UIImage) {
            self.contentType = type
            self.normalIcon = normalIcon
            self.selectedIcon = selectedIcon
            super.init()
            titleLabel.text = title
            updateConfiguration()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var isSelected: Bool = false {
            didSet {
                updateConfiguration()
            }
        }
        
        let contentType: Topic.ContentType
        private let normalIcon: UIImage
        private let selectedIcon: UIImage
        
        private let stackView: UIStackView = UIStackView(axis: .horizontal, spacing: 8)
        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(24)
            }
            return imageView
        }()
        private let titleLabel: UILabel = UILabel()
        
        override func style() {
            layer.cornerRadius = 40/2
        }
        
        override func hierarchy() {
            addSubview(stackView)
            stackView.addArrangedSubviews([iconImageView, titleLabel])
        }
        
        override func layout(){
            self.snp.makeConstraints{
                $0.height.equalTo(40)
            }
            stackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(8)
                $0.leading.equalToSuperview().offset(23)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
        }
        
        private func updateConfiguration() {
            if isSelected {
                titleLabel.textColor = Color.white
                titleLabel.font = Pretendard.bold16.font
                iconImageView.image = selectedIcon
                backgroundColor = Color.subNavy2
                layer.borderColor = nil
                layer.borderWidth = 0
            }
            else {
                titleLabel.textColor = Color.subPurple
                titleLabel.font = Pretendard.regular16.font
                iconImageView.image = normalIcon
                backgroundColor = Color.transparent
                layer.borderColor = Color.subNavy2.cgColor
                layer.borderWidth = 1
            }
        }
    }
}


extension TopicContentInputTableViewCell {
    
    class TextContentView: BaseStackView {
        
        private let switchButton: UIButton = {
           let button = UIButton()
            button.setImage(Image.topicGenerateSwitch, for: .normal)
            button.snp.makeConstraints{
                $0.width.height.equalTo(30)
            }
            return button
        }()
        private let aTextView: TextContentTextView = TextContentTextView(option: .A)
        private let bTextView: TextContentTextView = TextContentTextView(option: .B)
        
        override func style() {
            axis = .vertical
            spacing = 16
        }
        
        override func hierarchy() {
            addArrangedSubviews([aTextView, bTextView])
            addSubview(switchButton)
        }
        
        override func layout() {
            switchButton.snp.makeConstraints{
                $0.center.equalToSuperview()
            }
        }
        
        class TextContentTextView: UITextView {
            
            init(option: Choice.Option) {
                self.option = option
                super.init(frame: .zero, textContainer: nil)
                style()
                hierarchy()
                layout()
                initialize()
                bind()
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            private let option: Choice.Option
            private let placeholderLabel: UILabel = {
               let label = UILabel()
                label.text = "내용을 입력해주세요"
                label.textColor = Color.subPurple.withAlphaComponent(0.4)
                label.setTypo(Pretendard.medium16, setLineSpacing: true)
                return label
            }()
            private let optionLabel: UILabel = {
                let label = UILabel()
                label.setTypo(Pretendard.black128)
                return label
            }()
            private let countLabel: UILabel = {
                let label = UILabel()
                label.textColor = Color.subPurple
                label.setTypo(Pretendard.semibold14)
                return label
            }()
            private var cancellable: Set<AnyCancellable> = []
            
            private func style() {
                layer.masksToBounds = true
                layer.cornerRadius = 10
                textColor = Color.white
                font = Pretendard.medium16.font
                backgroundColor = Color.subNavy2.withAlphaComponent(0.6)
                textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 40)
                textContainer.maximumNumberOfLines = 3
                isScrollEnabled = false
            }
            
            private func hierarchy() {
                addSubviews([placeholderLabel, optionLabel, countLabel])
            }
            
            private func layout() {
                self.snp.makeConstraints{
                    $0.height.equalTo(80)
                }
                placeholderLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(12)
                    $0.leading.equalToSuperview().offset(16)
                }
                optionLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(-15)
                    $0.centerX.equalToSuperview()
                }
                countLabel.snp.makeConstraints{
                    $0.top.equalToSuperview().offset(13)
                    $0.leading.equalToSuperview().offset(Device.width-40-countLabel.intrinsicContentSize.width-16)
                }
            }
            
            private func initialize() {
                optionLabel.text = option.content.title
                optionLabel.textColor = option.content.color.withAlphaComponent(0.4)
            }
            
            private func bind() {
                publisher(for: .editingDidBegin)
                    .sink{ [weak self] _ in
                        guard let self = self else { return }
                        self.backgroundColor = Color.subNavy2.withAlphaComponent(0.4)
                        self.placeholderLabel.isHidden = true
                    }
                    .store(in: &cancellable)
                
                publisher(for: .editingDidEnd)
                    .sink{ [weak self] text in
                        guard let self = self else { return }
                        if text.isEmpty {
                            self.backgroundColor = Color.subNavy2.withAlphaComponent(0.6)
                            self.placeholderLabel.isHidden = false
                        }
                    }
                    .store(in: &cancellable)
            }
        }
    }
    
    class ImageContentView: BaseView {
        
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
        let aTextField = ImageContentTextField(option: .A)
        let bTextField = ImageContentTextField(option: .B)
        
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
