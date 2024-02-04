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

open class ABTextFieldView: BaseStackView {
    
    public enum State {
        /// 초기 상태로, placeholder를 보여준다
        case empty
        /// 편집 상태
        case editing
        /// 조건을 충족하지 못한 상태
        case error
    }
    
    public init(placeholder: String, insets: UIEdgeInsets, isErrorNeed: Bool) {
        self.isErrorNeed = isErrorNeed
        self.textField = InsetTextField(insets: insets)
        self.textField.placeholder = placeholder
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
    public var cancellable: Set<AnyCancellable> = []
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
    public let errorLabel: UILabel = UILabel()
    
    open override func style() {
        
        cornerRadius()
        stackViewProperties()
        
        func cornerRadius() {
            textField.layer.cornerRadius = 10
        }
        
        func stackViewProperties() {
            spacing = 9
            axis = .vertical
        }
    }
    
    open override func hierarchy() {
        addArrangedSubview(textField)
        if isErrorNeed {
            addArrangedSubview(errorLabel)
        }
        textField.addSubview(countLabel)
    }
    
    open override func layout() {
        textField.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
        }
        if isErrorNeed {
            errorLabel.snp.makeConstraints{
                $0.leading.equalToSuperview()
            }
        }
        countLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    open override func initialize() {
    
        setConfiguration()
        
        func setConfiguration() {
            let configuration = delegate?.configuration(self) ?? defaultABTextFieldViewConfiguration
            textField.backgroundColor = configuration.backgroundColor
            textField.textColor = configuration.textColor
            textField.font = configuration.font
            textField.customPlaceholder(font: configuration.font)
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
                    
                    guard let self = self else { return }
                    
                    updateConfiguration()
                    
                    func updateConfiguration() {
                        let configuration = self.delegate?.configuration(self, of: state) ?? self.configuration(of: state)
                        self.textField.layer.borderWidth = configuration.strokeWidth ?? 0
                        self.textField.layer.borderColor = configuration.strokeColor?.cgColor
                        self.countLabel.isHidden = configuration.isCountLabelHidden
                        self.errorLabel.layer.opacity = configuration.isErrorLabelHidden ? 0 : 1
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
    
    private func configuration(of state: ABTextFieldView.State) -> ABTextFieldViewStateConfiguration {
        switch state {
        case .empty:        return abTextFieldViewEmptyStateConfiguration
        case .editing:      return abTextFieldViewEditingStateConfiguration
        case .error:        return abTextFieldViewErrorStateConfiguration
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
    
    public func error(message: String?) {
        if (textField.text ?? "").count == 0 {
            state = .empty
        }
        else {
            state = .error
            errorLabel.text = message
        }
    }
    
    public func complete() {
        state = .editing
    }

    ///매개변수로 넘긴 값으로 text field의 값을 업데이트한다. 이때 글자 수도 함께 업데이트된다.
    public func update(text: String) {
        textField.text = text
        textField.sendActions(for: .editingChanged)
        textField.sendActions(for: .editingDidEnd)
    }
}
