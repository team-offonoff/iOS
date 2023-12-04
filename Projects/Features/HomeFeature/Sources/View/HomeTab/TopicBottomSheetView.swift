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
    
    var choiceResetItem: ItemStackView? {
        itemsStackView.viewWithTag(TopicBottomSheetFunction.reset.rawValue) as? ItemStackView
    }
    
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
                let item = ItemStackView(function: $0)
                item.tag = $0.rawValue
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
                isUserInteractionEnabled = !isDisabled
                setElement()
            }
        }
        
        private let function: TopicBottomSheetFunction
        
        init(function: TopicBottomSheetFunction) {
            self.function = function
            super.init()
            titleLabel.text = function.title
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
            setElement()
        }
        
        override func hierarchy() {
            addArrangedSubviews([iconImageView, titleLabel])
        }
        
        private func setElement() {
            iconImageView.image = isDisabled ? function.disabledIcon : function.defaultIcon
            titleLabel.textColor = isDisabled ? Color.black20 : Color.black
        }
    }
}

extension TopicBottomSheetFunction {
    
    var defaultIcon: UIImage {
        switch self {
        case .hide:     return Image.hide
        case .report:   return Image.report
        case .reset:    return Image.resetEnable
        }
    }
    
    var disabledIcon: UIImage? {
        switch self {
        case .reset:    return Image.resetDisable
        default:        return nil
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
