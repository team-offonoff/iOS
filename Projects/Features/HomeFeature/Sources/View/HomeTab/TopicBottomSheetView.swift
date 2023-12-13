//
//  TopicBottomSheetView.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/03.
//  Copyright © 2023 AB. All rights reserved.
//

import UIKit
import ABKit
import Domain
import Combine

final class TopicBottomSheetView: BaseView {
    
    var choiceResetItem: ItemStackView? {
        itemsStackView.viewWithTag(tag(of: TopicTemp.Action.reset)) as? ItemStackView
    }
    
    weak var delegate: TopicBottomSheetGestureDelegate?
    
    private var cancellable: Set<AnyCancellable> = []
    
    private let itemsStackView: UIStackView = UIStackView(axis: .vertical, spacing: 20)
    
    override func style() {
        layer.cornerRadius = 24
        backgroundColor = Color.white
    }
    
    override func hierarchy() {
        
        addSubviews([itemsStackView])
        addItems()

        func addItems() {
            TopicTemp.Action.forBottomSheet.forEach{ action in
                let item = ItemStackView(action: action)
                item.tag = tag(of: action)
                item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(functionTap)))
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

    @objc private func functionTap(_ recognizer: UITapGestureRecognizer) {
        recognizer.view
            .publisher
            .sink{ [weak self] view in
                guard let item = view as? ItemStackView else { return }
                self?.delegate?.tap(action: item.action)
            }
            .store(in: &cancellable)
    }
    
    private func tag(of action: TopicTemp.Action) -> Int {
        action.hashValue
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
        
        let action: TopicTemp.Action
        
        init(action: TopicTemp.Action) {
            self.action = action
            super.init()
            titleLabel.text = action.content.title
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
            iconImageView.image = isDisabled ? action.content.disabledIcon : action.content.defaultIcon
            titleLabel.textColor = isDisabled ? Color.black20 : Color.black
        }
    }
}
