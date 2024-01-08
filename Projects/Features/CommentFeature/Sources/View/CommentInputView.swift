//
//  CommentInputView.swift
//  CommentFeature
//
//  Created by 박소윤 on 2024/01/02.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import FeatureDependency
import Domain

protocol CommentSendDelegate: AnyObject {
    func send(sender: DelegateSender, comment: String)
}

final class CommentInputView: BaseView {
    
    enum InputState {
        case register
        case modify
    }
    
    var inputState: InputState = .register
    weak var delegate: CommentSendDelegate?
    
    private let borderLine: UIView = {
       let view = UIView()
        view.backgroundColor = Color.black.withAlphaComponent(0.1)
        view.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        return view
    }()
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "댓글 입력"
        label.textColor = Color.black.withAlphaComponent(0.4)
        label.setTypo(Pretendard.regular14)
        return label
    }()
    private let defaultTextViewHeight: CGFloat = 36
    private let textView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = Color.black.withAlphaComponent(0.1)
        textView.textColor = Color.black.withAlphaComponent(0.4)
        textView.font = Pretendard.regular14.font
        textView.layer.cornerRadius = 10
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        return textView
    }()
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("send", for: .normal)
        button.setTitleColor(Color.black, for: .normal)
        button.setTitleColor(Color.black40, for: .disabled)
        return button
    }()
    private var cancellable: Set<AnyCancellable> = []
    
    override func style() {
        backgroundColor = Color.white
    }
    
    override func hierarchy() {
        addSubviews([borderLine, textView, sendButton])
        textView.addSubview(placeholderLabel)
    }
    
    override func layout() {
        borderLine.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        textView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(32)
            $0.height.equalTo(defaultTextViewHeight)
        }
        placeholderLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
        sendButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(textView)
        }
    }
    
    override func initialize() {
        
        textView.publisher(for: .editingChanged)
            .sink{ [weak self] text in
                
                guard let self = self else { return }
                
                let size = CGSize(width: Device.width, height: .infinity)
                let estimatedSize = self.textView.sizeThatFits(size)
                
                let maxHeight = self.textView.font!.lineHeight * 3 + self.textView.textContainerInset.top * 2 + 10
                
                let newHeight: CGFloat = {
                    if estimatedSize.height < self.defaultTextViewHeight {
                        return self.defaultTextViewHeight
                    }
                    if estimatedSize.height > maxHeight {
                        return maxHeight
                    }
                    return estimatedSize.height
                }()
                
                self.textView.isScrollEnabled = newHeight == maxHeight
                
                self.textView.constraints.forEach { (constraint) in
                    if constraint.firstAttribute == .height {
                        constraint.constant = newHeight
                    }
                }
                
                self.sendButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .store(in: &cancellable)
        
        textView.publisher(for: .editingDidBegin)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.placeholderLabel.isHidden = true
            }
            .store(in: &cancellable)
        
        textView.publisher(for: .editingDidEnd)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] text in
                
                guard let self = self else { return }
                
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.clear()
                }
            }
            .store(in: &cancellable)
        
        
        sendButton.tapPublisher
            .sink{ [weak self] _ in
                
                guard let self = self else { return }
                
                self.delegate?.send(sender: .init(identifier: identifier()), comment: self.textView.text)
                
                func identifier() -> String {
                    switch self.inputState {
                    case .register:     return Comment.Action.register.identifier
                    case .modify:       return Comment.Action.modify.identifier
                    }
                }
            }
            .store(in: &cancellable)
    }
    
    func fill(text: String) {
        textView.text = text
        NotificationCenter.default.post(name: UITextView.textDidBeginEditingNotification, object: self.textView)
    }
    
    func clear() {
        defer {
            inputState = .register
        }
        textView.resignFirstResponder()
        textView.text = ""
        NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: self.textView)
    }
}
