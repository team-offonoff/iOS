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
import TopicFeatureInterface
import FeatureDependency
import Domain
import Combine

protocol ImageTextIncludeContentView: UIView {
    //타입 상관없는 publisher로 사용하는 건 어떤지
    var aTextPublisher: AnyPublisher<String, Never>? { get }
    var bTextPublisher: AnyPublisher<String, Never>? { get }
    var aImagePublisher: AnyPublisher<UIImage?, Never>? { get }
    var bImagePublisher: AnyPublisher<UIImage?, Never>? { get }
    func text(option: Choice.Option) -> String?
    func image(option: Choice.Option) -> UIImage?
}

/*
final class TopicContentInputTableViewCell: BaseTableViewCell {
    
    private var selectedContentTypeChip: ContentTypeChip? {
        willSet {
            newValue?.isSelected = true
        }
        didSet {
            oldValue?.isSelected = false
        }
    }

    private let contentTypeChips: ContentTypeGroup = ContentTypeGroup()
    private let contentSubView: SubtitleView = SemiboldSubtitleView(subtitle: "토픽 내용", content: UIView())
    private let textContentView: TextContentView = TextContentView()
    private let imageContentView: ImageContentView = ImageContentView()
    private let deadlineSubView: SubtitleView = SemiboldSubtitleView(subtitle: "마감 시간", content: DropDownView(placeholder: "1시간 뒤"))
    let ctaButton: CTAButton = {
        let button = CTAButton(title: "토픽 올리기")
        button.isEnabled = false
        return button
    }()
    
    private var cancellable: Set<AnyCancellable> = []
    private var contentViewBottomConstraints: [NSLayoutConstraint] = [] //content view의 하단 레이아웃 조정을 위한 배열
    
    
    //MARK: - Override
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    
    override func hierarchy() {
        contentTypeChips.stackView.addArrangedSubviews([contentTypeChips.text, contentTypeChips.image])
        baseView.addSubviews([contentTypeChips.stackView, contentSubView, deadlineSubView, ctaButton])
        contentSubView.contentView.addSubviews([textContentView, imageContentView])
    }
    
    override func layout() {
        baseView.snp.makeConstraints{
            $0.height.equalTo(Device.height - (Device.safeAreaInsets?.top ?? 0) - 48 - 30)
        }
        contentTypeChips.stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        contentSubView.snp.makeConstraints{
            $0.top.equalTo(contentTypeChips.stackView.snp.bottom).offset(30)
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
        initChip()
        addGestureRecognizer()
        addButtonTarget()
        
        func initChip() {
            selectedContentTypeChip = contentTypeChips.text
        }
        
        func addGestureRecognizer() {
            [contentTypeChips.text, contentTypeChips.image].forEach{
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeContentType)))
            }
        }
        
        func addButtonTarget() {
            ctaButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.delegate?.tap(DelegateSender(identifier: String(describing: self)))
                }
                .store(in: &cancellable)
        }
    }
    
    @objc private func changeContentType(_ recognizer: UITapGestureRecognizer) {
        
        guard let view = recognizer.view as? ContentTypeChip else { return }
        
        if viewModel?.contentType.value != view.contentType {
            selectedContentTypeChip = view
            viewModel?.contentType.send(view.contentType)
        }
    }
    
    private func bind() {
        viewModel?.contentType
            .sink{ [weak self] type in
                
                self?.updateContentTypeView()
                self?.updateViewModelInput()
                resetInput()
                resetButton()
                
                func resetInput() {
                    switch type {
                    case .text:     self?.imageContentView.reset()
                    case .image:    self?.textContentView.reset()
                    }
                }
                
                func resetButton() {
                    self?.ctaButton.isEnabled = false
                }
                
            }
            .store(in: &cancellable)
    }
    
    //MARK: - Input
    
    weak var delegate: TapDelegate?
    
    var viewModel: (any TopicGenerateViewModel)?{
        didSet{
            updateViewModelInput()
            updateContentTypeView()
            bind()
            setLimitCount()
        }
    }
    
    func setImage(_ image: UIImage, option: Choice.Option) {
        imageContentView.setImage(image, option: option)
    }
    
    private func setLimitCount() {
        imageContentView.setLimitCount(viewModel?.limitCount.imageComment)
        textContentView.setLimitCount(viewModel?.limitCount.textOption)
    }
    
    private func updateViewModelInput() {
        viewModel?.input(choiceContent: .init(
            choiceAText: currentContentView().aTextPublisher,
            choiceBText: currentContentView().bTextPublisher,
            choiceAImage: currentContentView().aImagePublisher,
            choiceBImage: currentContentView().bImagePublisher
        ))
    }
    
    private func currentContentView() -> ImageTextIncludeContentView {
        switch viewModel?.contentType.value {
        case .text:     return textContentView
        case .image:    return imageContentView
        default:        fatalError()
        }
    }
    
    private func updateContentTypeView() {
        
        guard let superview = currentContentView().superview else { return }
        
        deactiveExistingConstraints()
        changeVisibility()
        newConstraints()
        
        func deactiveExistingConstraints() {
            NSLayoutConstraint.deactivate(contentViewBottomConstraints)
        }
        
        func newConstraints() {
            contentViewBottomConstraints = [currentContentView().bottomAnchor.constraint(equalTo: superview.bottomAnchor)]
            NSLayoutConstraint.activate(contentViewBottomConstraints)
            contentSubView.contentView.layoutIfNeeded()
        }
        
        func changeVisibility() {
            currentContentView().isHidden = false
            unselectedContentView().forEach{
                $0.isHidden = true
            }
        }
        
        func unselectedContentView() -> [UIView] {
            [textContentView, imageContentView].filter{ $0 != currentContentView() }
        }
    }
}

//MARK: Output

extension TopicContentInputTableViewCell {
    func registerText(option: Choice.Option) -> String {
        currentContentView().text(option: option)
    }
    
    func registerImage(option: Choice.Option) -> UIImage? {
        currentContentView().image(option: option)
    }
}

*/
