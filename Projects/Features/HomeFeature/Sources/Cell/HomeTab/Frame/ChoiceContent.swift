//
//  ChoiceContent.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/04.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Domain
import Core
import FeatureDependency

protocol ChoiceContent{
    init(choice: Choice)
    var views: [UIView] { get }
    func setALayout()
    func setBLayout()
}

extension ChoiceContent {
    var visibleWidth: CGFloat {
        UIScreen.main.bounds.size.width/2 + 7.5 - 55
    }
}

extension HomeTopicCollectionViewCell {
    
    final class TextChoiceContent: ChoiceContent {
        
        var views: [UIView] {
            [contentLabel]
        }
        
        private let choice: Choice
        
        init(choice: Choice) {
            self.choice = choice
            contentLabel.text = choice.content.text
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let contentLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.semibold20, setLineSpacing: true)
            label.textColor = Color.white
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        func setALayout() {
            contentLabel.snp.makeConstraints{
                $0.centerY.centerX.equalToSuperview()
                $0.leading.equalTo(visibleWidth+44)
                $0.trailing.equalToSuperview().inset(44)
            }
        }
        
        func setBLayout() {
            contentLabel.snp.makeConstraints{
                $0.centerY.centerX.equalToSuperview()
                $0.leading.equalToSuperview().inset(44)
                $0.trailing.equalToSuperview().inset(visibleWidth+44)
            }
        }
    }
    
    final class ImageChoiceContent: ChoiceContent {
        
        var views: [UIView] {
            [buttonStackView, imageView]
        }
        
        private let choice: Choice
        
        init(choice: Choice) {
            self.choice = choice
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = Color.black
            imageView.layer.cornerRadius = 136/2
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(136)
            }
            return imageView
        }()
        
        private lazy var buttonStackView: UIStackView = {
            let stackView = UIStackView(axis: .vertical, spacing: 4)
            stackView.addArrangedSubviews([imageExpandIcon])
            stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(action)))
            return stackView
        }()
//        private let textExpandButton: UIButton = {
//            let button = UIButton()
//            button.setImage(Image.choiceTextExpand, for: .normal)
//            button.snp.makeConstraints{
//                $0.width.height.equalTo(24)
//            }
//            return button
//        }()
        private let imageExpandIcon: UIImageView = {
            let button = UIImageView()
            button.image = Image.choiceImageExpand
            button.snp.makeConstraints{
                $0.width.height.equalTo(24)
            }
            return button
        }()
        
        @objc private func tap(_ recognizer: UITapGestureRecognizer) {
            //home view controller로 이벤트 전달
            NotificationCenter.default
                .post(
                    name: NSNotification.Name(Topic.Action.expandImage.identifier),
                    object: self,
                    //TODO: #55 이후 키값 변경 예정
                    userInfo: ["Choice": choice]
                )
        }
        
        func setALayout() {
            buttonStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(6)
                $0.leading.equalToSuperview().offset(visibleWidth+6)
            }
            imageView.snp.makeConstraints{
                $0.top.bottom.trailing.equalToSuperview().inset(6)
            }
        }
        
        func setBLayout() {
            buttonStackView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(6)
                $0.trailing.equalToSuperview().inset(visibleWidth+6)
            }
            imageView.snp.makeConstraints{
                $0.top.bottom.leading.equalToSuperview().inset(6)
            }
        }
    }
}
