//
//  OnboardingTextFieldView.swift
//  ABKit
//
//  Created by 박소윤 on 2023/12/22.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

fileprivate protocol OnboardingTextFieldViewConfiguration {
    var backgroundColor: UIColor { get }
    var strokeWidth: CGFloat? { get }
    var strokeColor: UIColor? { get }
    var isCountLabelHidden: Bool { get }
    var isErrorLabelHidden: Bool { get }
}

public final class OnboardingTextFieldView: BaseView {
    
    public enum State {
        /// 초기 상태로, placeholder를 보여준다
        case empty
        /// 편집 상태
        case editing
        /// 조건을 충족하지 못한 상태
        case error
        /// 조건을 충족하고, 입력을 마친 상태
        case complete
    }
    
    public init(placeholder: String) {
        self.placeholder = placeholder
        super.init()
        bind()
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Published public var state: State = .empty
    
    public let textField: InsetTextField = {
        let textField = InsetTextField()
        textField.textColor = Color.subPurple
        textField.font = Pretendard.semibold14.font
        textField.layer.cornerRadius = 10
        return textField
    }()
    public let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0/8"
        label.textColor = Color.subPurple
        label.setTypo(Pretendard.semibold14)
        return label
    }()
    public let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "* 한글, 영문, 숫자만 가능해요."
        label.textColor = Color.subPurple2
        label.setTypo(Pretendard.semibold13)
        return label
    }()
    
    private let placeholder: String
    private var cancellable: Set<AnyCancellable> = []
    
    public override func style() {

        setCustomPlaceholder()
        
        func setCustomPlaceholder() {
            let attributedPlaceholder = NSMutableAttributedString(string: placeholder)
            attributedPlaceholder.addAttributes([
                .font: Pretendard.semibold14.font,
                .foregroundColor: Color.subPurple
            ], range: NSRange(location: 0, length: placeholder.count))
            textField.attributedPlaceholder = NSAttributedString(attributedString: attributedPlaceholder)
        }
    }
    
    public override func hierarchy() {
        addSubviews([textField, errorLabel])
        textField.addSubview(countLabel)
    }
    
    public override func layout() {
        textField.snp.makeConstraints{
            $0.height.equalTo(48)
            $0.leading.trailing.top.equalToSuperview()
        }
        errorLabel.snp.makeConstraints{
            $0.top.equalTo(textField.snp.bottom).offset(9)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        countLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        $state
            .sink{ [weak self] state in
                
                guard let self = self else { return }
                
                let configuration = configuration()
                self.textField.backgroundColor = configuration.backgroundColor
                self.textField.layer.borderWidth = configuration.strokeWidth ?? 0
                self.textField.layer.borderColor = configuration.strokeColor?.cgColor
                self.countLabel.isHidden = configuration.isCountLabelHidden
                self.errorLabel.isHidden = configuration.isErrorLabelHidden
                
                func configuration() -> OnboardingTextFieldViewConfiguration {
                    switch state {
                    case .empty:        return EmptyStateConfiguration()
                    case .editing:      return EditingStateConfiguration()
                    case .error:        return ErrorStateConfiguration()
                    case .complete:     return CompleteStateConfiguration()
                    }
                }
            }
            .store(in: &cancellable)
    }
}

fileprivate struct EmptyStateConfiguration: OnboardingTextFieldViewConfiguration {
    let backgroundColor: UIColor = Color.transparent
    let strokeWidth: CGFloat? = 1
    let strokeColor: UIColor? = Color.subPurple.withAlphaComponent(0.4)
    let isCountLabelHidden: Bool = true
    let isErrorLabelHidden: Bool = true
}

fileprivate struct EditingStateConfiguration: OnboardingTextFieldViewConfiguration {
    let backgroundColor: UIColor = Color.transparent
    let strokeWidth: CGFloat? = 1
    let strokeColor: UIColor? = Color.subPurple.withAlphaComponent(0.4)
    let isCountLabelHidden: Bool = false
    let isErrorLabelHidden: Bool = true
}

fileprivate struct ErrorStateConfiguration: OnboardingTextFieldViewConfiguration {
    let backgroundColor: UIColor = Color.transparent
    let strokeWidth: CGFloat? = 1
    let strokeColor: UIColor? = Color.subPurple2
    let isCountLabelHidden: Bool = false
    let isErrorLabelHidden: Bool = false
}

fileprivate struct CompleteStateConfiguration: OnboardingTextFieldViewConfiguration {
    let backgroundColor: UIColor = Color.subNavy2
    let strokeWidth: CGFloat? = nil
    let strokeColor: UIColor? = nil
    let isCountLabelHidden: Bool = false
    let isErrorLabelHidden: Bool = true
}
