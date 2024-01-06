//
//  ABTextFieldView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

open class ABTextFieldView: BaseView {
    
    public enum State {
        /// 초기 상태로, placeholder를 보여준다
        case empty
        /// 편집 상태
        case editing
        /// 조건을 충족하지 못한 상태
        case error
    }
    
    public init(placeholder: String, insets: UIEdgeInsets, isErrorNeed: Bool) {
        self.placeholder = placeholder
        self.isErrorNeed = isErrorNeed
        self.textField = InsetTextField(insets: insets)
        super.init()
        bind()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published public var state: State = .empty
    public weak var delegate: ABTextFieldViewDelegate? {
        didSet {
            state = .empty
        }
    }
    
    private let isErrorNeed: Bool
    private let placeholder: String
    private var cancellable: Set<AnyCancellable> = []
    ///글자 제한 수를 설정할 경우, 자동으로 카운팅이 동작하며, Lable에 개수를 업데이트한다.
    public var limitCount: Int? {
        didSet {
            if limitCount != nil {
                bindTextCount()
            }
        }
    }
    
    public let textField: InsetTextField
    public let countLabel: UILabel = UILabel()
    private let errorLabel: UILabel = UILabel()
    
    open override func style() {
        textField.layer.cornerRadius = 10
    }
    
    public func customPlaceholder(color: UIColor = Color.subPurple.withAlphaComponent(0.6), font: UIFont) {
        let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
        attributedPlaceholder.addAttributes([
            .font: font,
            .foregroundColor: color
        ], range: NSRange(location: 0, length: placeholder.count))
        textField.attributedPlaceholder = NSAttributedString(attributedString: attributedPlaceholder)
    }
    
    public override func hierarchy() {
        addSubviews([textField, errorLabel])
        textField.addSubview(countLabel)
    }
    
    public override func layout() {
        textField.snp.makeConstraints{
            $0.leading.trailing.top.equalToSuperview()
        }
        if isErrorNeed {
            errorLabel.snp.makeConstraints{
                $0.top.equalTo(textField.snp.bottom).offset(9)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        else {
            textField.snp.makeConstraints{
                $0.bottom.equalToSuperview()
            }
        }
        countLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    public override func initialize() {
        
        delegate = self
        textField.placeholder = placeholder
        setConfiguration()
        
        func setConfiguration() {
            let configuration = configuration(self)
            textField.backgroundColor = configuration.backgroundColor
            textField.textColor = configuration.textColor
            countLabel.textColor = configuration.countColor
            countLabel.font = configuration.countFont
            errorLabel.textColor = configuration.errorColor
            errorLabel.font = configuration.errorFont
            //error label 크기를 잡기 위한 임시 데이터 삽입
            errorLabel.text = "error"
        }
    }
    
    private func bind() {
        
        bindState()
        bindTextFieldEditingBegin()
        
        func bindState() {
            $state
                .sink{ [weak self] state in
                   
                    guard let self = self, let delegate = self.delegate else { return }
                    
                    updateConfiguration()
                    
                    func updateConfiguration() {
                        let configuration = delegate.configuration(self, of: state)
                        self.textField.layer.borderWidth = configuration.strokeWidth ?? 0
                        self.textField.layer.borderColor = configuration.strokeColor?.cgColor
                        self.countLabel.isHidden = configuration.isCountLabelHidden
                        self.errorLabel.isHidden = configuration.isErrorLabelHidden
                    }
                }
                .store(in: &cancellable)
        }
        
        func bindTextFieldEditingBegin() {
            textField.publisher(for: .editingDidBegin)
                .sink{ [weak self] _ in
                    guard let self = self else { return }
                    self.state = .editing
                }
                .store(in: &cancellable)
        }
    }
    
    private func bindTextCount() {
        countLabel.text = "\(0)/\(limitCount!)"
        textField.publisher(for: .editingChanged)
            .sink{ [weak self] in
                
                guard let self = self, let limitCount = self.limitCount else { return }
                
                self.state = .editing
                self.countLabel.text = "\($0.count)/\(limitCount)"
            }
            .store(in: &cancellable)
    }
}

//MARK: Input

extension ABTextFieldView {
    
    public func error(message: String) {
        if (textField.text ?? "").count == 0 {
            state = .empty
        }
        else {
            state = .error
            errorLabel.text = message
        }
    }
    ///매개변수로 넘긴 값으로 text field의 값을 업데이트한다. 이때 글자 수도 함께 업데이트된다.
    public func update(text: String) {
        textField.text = text
        textField.sendActions(for: .editingChanged)
        textField.sendActions(for: .editingDidEnd)
    }
}

///delegate를 새로 선언하지 않을 경우, 초기 구현된 configuration을 사용합니다.
extension ABTextFieldView: ABTextFieldViewDelegate {
    
}