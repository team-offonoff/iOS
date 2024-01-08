//
//  TextContentView.swift
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
    
    class TextContentView: BaseStackView, ImageTextIncludeContentView {
        
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
        private var cancellable: Set<AnyCancellable> = []
        
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
        
        override func initialize() {
            switchButton.tapPublisher
                .sink{ [weak self] _ in
                    guard let self = self else { return }
                    let temp = self.aTextView.text ?? ""
                    self.aTextView.setText(self.bTextView.text)
                    self.bTextView.setText(temp)
                }
                .store(in: &cancellable)
        }
        
        //MARK: Input
        
        func reset() {
            aTextView.setText("")
            bTextView.setText("")
        }
        
        func setLimitCount(_ count: Int?) {
            aTextView.limitCount = count
            bTextView.limitCount = count
        }
        
        //MARK: Output
        
        func text(option: Choice.Option) -> String {
            switch option {
            case .A:    return aTextView.text
            case .B:    return bTextView.text
            }
        }
        func image(option: Choice.Option) -> UIImage? {
            nil
        }
        
        var aTextPublisher: AnyPublisher<String, Never> {
            aTextView.publisher(for: .editingDidEnd)
        }
        var bTextPublisher: AnyPublisher<String, Never> {
            bTextView.publisher(for: .editingDidEnd)
        }
        
        var aImagePublisher: AnyPublisher<UIImage?, Never>? {
            nil
        }
        var bImagePublisher: AnyPublisher<UIImage?, Never>? {
            nil
        }
    }
}

extension TopicContentInputTableViewCell {
    
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
            label.text = "0/0"
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
                    if text.isEmpty {
                        self?.backgroundColor = Color.subNavy2.withAlphaComponent(0.6)
                        self?.placeholderLabel.isHidden = false
                    }
                }
                .store(in: &cancellable)
        }
        
        //MARK: Input
        
        var limitCount: Int? {
            didSet {
                setTextCount()
                bindTextCount()
                
                func bindTextCount() {
                    publisher(for: .editingChanged)
                        .sink{ _ in
                            setTextCount()
                        }
                        .store(in: &cancellable)
                }
                
                func setTextCount() {
                    guard let limitCount = limitCount else { return }
                    countLabel.text = "\(text.count)/\(limitCount)"
                }
            }
        }
        
        ///매개변수로 넘긴 값으로 text 업데이트 및 글자 수 등 커스텀 Text View의 속성이 자동으로 업데이트 된다.
        func setText(_ text: String) {
            self.text = text
            NotificationCenter.default.post(name: UITextView.textDidBeginEditingNotification, object: self)
            NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self)
            NotificationCenter.default.post(name: UITextView.textDidEndEditingNotification, object: self)
        }
        
        //MARK: Output
    }
}
