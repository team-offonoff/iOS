//
//  ContentTypeGroup.swift
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
    
    class ContentTypeGroup {
        let stackView: UIStackView = {
            let stackView = UIStackView(axis: .horizontal, spacing: 8)
            stackView.alignment = .center
            return stackView
        }()
        let text: ContentTypeChip = ContentTypeChip(type: .text, title: "텍스트", normalIcon: Image.topicGenerateTextNoraml, selectedIcon: Image.topicGenerateTextSelected)
        let image: ContentTypeChip = ContentTypeChip(type: .image, title: "이미지", normalIcon: Image.topicGenerateImageNormal, selectedIcon: Image.topicGenerateTextSelected)
    }
    
    final class ContentTypeChip: BaseView {
        
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
