//
//  TopicBottomSheetView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/03.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Core

final class TopicBottomSheetView: BaseView {
    
    private let itemsStackView: UIStackView = UIStackView(axis: .vertical, spacing: 20)
    
    override func style() {
        layer.cornerRadius = 24
        backgroundColor = Color.white
    }
    
    override func hierarchy() {
        
        addSubviews([itemsStackView])
        addItems()

        func addItems() {
            TopicBottomSheetFunction.allCases.forEach{
                let item = ItemStackView(icon: $0.icon, title: $0.title)
                itemsStackView.addArrangedSubview(item)
            }
        }
    }
    
    override func layout() {
        itemsStackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

extension TopicBottomSheetView {
    
    final class ItemStackView: BaseStackView {
        
        var isDisabled: Bool = false {
            didSet {
                setElementColor()
            }
        }
        
        init(icon: UIImage, title: String) {
            super.init()
            iconImageView.image = icon
            titleLabel.text = title
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.snp.makeConstraints{
                $0.width.height.equalTo(26)
            }
            return imageView
        }()
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.setTypo(Pretendard.medium16)
            return label
        }()
        
        override func style() {
            axis = .horizontal
            spacing = 14
            setElementColor()
        }
        
        override func hierarchy() {
            addArrangedSubviews([iconImageView, titleLabel])
        }
        
        private func setElementColor() {
            let color = isDisabled ? Color.black20 : Color.black
            iconImageView.image?.withTintColor(color)
            titleLabel.textColor = color
        }
    }
}

extension TopicBottomSheetFunction {
    var icon: UIImage {
        switch self {
        case .hide:     return Image.hide
        case .report:   return Image.report
        case .reset:    return Image.reset
        }
    }
    
    var title: String {
        switch self {
        case .hide:     return "이런 토픽은 안볼래요"
        case .report:   return "신고하기"
        case .reset:    return "투표 다시 하기"
        }
    }
}
