//
//  TopicGenerateBSideSecondView.swift
//  TopicFeature
//
//  Created by 박소윤 on 2024/01/20.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain
import Combine

protocol ContentPublisher: UIView {
    var contentA: AnyPublisher<Any?, Never> { get }
    var contentB: AnyPublisher<Any?, Never> { get }
    func content(option: Choice.Option) -> Any?
    func switchOption()
}

final class TopicGenerateBSideSecondView: BaseView {
    
    let previousInformation: PreviousInformation = PreviousInformation()
    let contentTypeChips: ContentTypeChips = ContentTypeChips()
    let contentSection: SubtitleView = RegularSubtitleView(subtitle: "어떤 선택지가 있나요?", content: UIView())
    let optionSwitch: SwitchView = SwitchView()
    let textContentView: TextContentView = TextContentView()
    let imageContentView: ImageContentView = ImageContentView()
    let deadlineSection: DeadlineSection = DeadlineSection()
    let pageIndicator: PageNumberIndicator = {
       let view =  PageNumberIndicator()
        view.cells[1].highlight()
        return view
    }()
    let ctaButton: CTAButton = CTAButton(title: "토픽 던지기")
    
    private var contentViewBottomConstraints: [NSLayoutConstraint] = [] //content view의 하단 레이아웃 조정을 위한 배열
    
    override func hierarchy() {
        addSubviews([previousInformation.stackView, previousInformation.separatorLine, contentTypeChips, contentSection, deadlineSection, pageIndicator, ctaButton])
        previousInformation.stackView.addArrangedSubviews([previousInformation.titleLabel, previousInformation.keywordLabel])
        contentSection.addSubview(optionSwitch)
        contentSection.contentView.addSubviews([textContentView, imageContentView])
    }
    
    override func layout() {
        previousInformation.stackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        previousInformation.separatorLine.snp.makeConstraints{
            $0.top.equalTo(previousInformation.stackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        contentTypeChips.snp.makeConstraints{
            $0.top.equalTo(previousInformation.separatorLine.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        contentSection.snp.makeConstraints{
            $0.top.equalTo(contentTypeChips.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        optionSwitch.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2)
            $0.trailing.equalToSuperview()
        }
        textContentView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        imageContentView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
        }
        deadlineSection.snp.makeConstraints{
            $0.top.equalTo(contentSection.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        pageIndicator.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(66)
        }
        ctaButton.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(ctaButton.defaultOffset.side)
            $0.bottom.equalToSuperview().inset(ctaButton.defaultOffset.bottom)
        }
    }
    
    func view(of contentType: Topic.ContentType) -> ContentPublisher {
        switch contentType {
        case .text:     return textContentView
        case .image:    return imageContentView
        }
    }
    
    func update(to contentType: Topic.ContentType) {
        
        guard let superview = view(of: contentType).superview else { return }
        
        reset()
        deactiveExistingConstraints()
        newConstraints()
        changeVisibility()
        
        func reset() {
            switch contentType {
            case .text:     imageContentView.reset()
            case .image:    textContentView.reset()
            }
//            ctaButton.isEnabled = false
        }
        
        func deactiveExistingConstraints() {
            NSLayoutConstraint.deactivate(contentViewBottomConstraints)
        }
        
        func newConstraints() {
            contentViewBottomConstraints = [view(of: contentType).bottomAnchor.constraint(equalTo: superview.bottomAnchor)]
            NSLayoutConstraint.activate(contentViewBottomConstraints)
            contentSection.contentView.layoutIfNeeded()
        }
        
        func changeVisibility() {
            view(of: contentType).isHidden = false
            unselectedContentView().forEach{
                $0.isHidden = true
            }
        }
        
        func unselectedContentView() -> [UIView] {
            [textContentView, imageContentView].filter{ $0 != view(of: contentType) }
        }
    }
    
}

extension TopicGenerateBSideSecondView {
    
    final class PreviousInformation: BaseStackView {
        let stackView: UIStackView = UIStackView(axis: .horizontal, spacing: 12, alignment: .center)
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white20
            label.font = Pretendard.semibold14.font
            return label
        }()
        let keywordLabel: UILabel = {
            let label = UILabel()
            label.textColor = Color.white20
            label.font = Pretendard.regular13.font
            return label
        }()
        let separatorLine: SeparatorLine = SeparatorLine(color: Color.white20, height: 1)
    }
    
    class ContentTypeChips: BaseStackView {
        
        let text: ContentTypeChip = ContentTypeChip(type: .text, normalIcon: Image.topicGenerateTextNoraml, selectedIcon: Image.topicGenerateTextSelected)
        let image: ContentTypeChip = ContentTypeChip(type: .image,normalIcon: Image.topicGenerateImageNormal, selectedIcon: Image.topicGenerateImageSelected)
        
        override func style() {
            axis = .horizontal
            spacing = 8
        }
        
        override func hierarchy() {
            addArrangedSubviews([text, image])
        }
    }
    
    final class ContentTypeChip: UIImageView {
        
        init(type: Topic.ContentType, normalIcon: UIImage, selectedIcon: UIImage) {
            self.contentType = type
            self.normalIcon = normalIcon
            self.selectedIcon = selectedIcon
            super.init(image: normalIcon)
            snp.makeConstraints{
                $0.width.height.equalTo(42)
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var isSelected: Bool = false {
            didSet {
                image = isSelected ? selectedIcon : normalIcon
            }
        }
        
        let contentType: Topic.ContentType
        private let normalIcon: UIImage
        private let selectedIcon: UIImage
    }
}

extension TopicGenerateBSideSecondView {
    
    class TextContentView: BaseStackView, ContentPublisher {

        private let optionA: OptionTextFieldView = {
            let view = OptionTextFieldView(option: .A)
            view.errorLabel.isHidden = true
            return view
        }()
        private let optionB: OptionTextFieldView = OptionTextFieldView(option: .B)
        private var cancellable: Set<AnyCancellable> = []
        
        override func style() {
            axis = .vertical
            spacing = 16
        }
        
        override func hierarchy() {
            addArrangedSubviews([optionA, optionB])
        }
        
        //MARK: Input
        
        func reset() {
            optionA.update(text: "")
            optionB.update(text: "")
        }
        
        func setLimitCount(_ count: Int?) {
            optionA.limitCount = count
            optionB.limitCount = count
        }
        
        func switchOption() {
            let temp = optionA.textField.text ?? ""
            optionA.update(text: optionB.textField.text ?? "")
            optionB.update(text: temp)
        }
        
        //MARK: Output
        
        var contentA: AnyPublisher<Any?, Never> {
            optionA.textField.anyPublisher(for: .editingDidEnd)
        }
        var contentB: AnyPublisher<Any?, Never> {
            optionB.textField.anyPublisher(for: .editingDidEnd)
        }
        
        func content(option: Choice.Option) -> Any? {
            switch option {
            case .A:    return optionA.textField.text ?? ""
            case .B:    return optionB.textField.text ?? ""
            }
        }
    }
}

extension TopicGenerateBSideSecondView {
    
    final class DeadlineSection: BaseStackView {
        
        var menu: UIMenu? {
            didSet {
                deadlineMenu.menu = menu
            }
        }
 
        let arrow: UIImageView = {
            let view = UIImageView(image: Image.down.withTintColor(Color.subPurple))
            view.snp.makeConstraints{
                $0.width.height.equalTo(24)
            }
            return view
        }()
        let commentStackView: UIStackView = UIStackView(axis: .horizontal, spacing: 4)
        let deadlineLabel: UILabel = {
            let label = UILabel()
            label.text = "1시간 뒤"
            label.textColor = Color.subPurple
            label.font = Pretendard.medium15.font
            return label
        }()
        let explainLabel: UILabel = {
            let label = UILabel()
            label.text = "토픽을 마감해요"
            label.textColor = Color.white60
            label.font = Pretendard.regular15.font
            return label
        }()
        private lazy var deadlineMenu: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled = true
            button.showsMenuAsPrimaryAction = true
            return button
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 6
        }
        
        override func hierarchy() {
            addArrangedSubviews([arrow, commentStackView])
            commentStackView.addArrangedSubviews([deadlineLabel, explainLabel])
            addSubview(deadlineMenu)
            deadlineMenu.snp.makeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
