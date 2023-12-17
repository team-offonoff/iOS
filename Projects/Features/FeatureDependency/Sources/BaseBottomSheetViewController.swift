//
//  BaseBottomSheetViewController.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/16.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine

public protocol BottomSheetAction {
    var content: BottomSheetActionContent { get }
}

public protocol BottomSheetActionContent {
    var defaultIcon: UIImage { get }
    var disabledIcon: UIImage? { get }
    var title: String { get }
}

open class BaseBottomSheetViewController: UIViewController {
    
    public init(actions: [any BottomSheetAction]){
        self.actions = actions
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public let actions: [any BottomSheetAction]
    public let mainView: BaseBottomSheetView = BaseBottomSheetView()
    public var cancellable: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        
        modalSetting()
        layout()
        addItems()
        initialize()
        bind()
        
        func modalSetting() {
           
            guard let sheetPresentationController = sheetPresentationController else { return }

            let detent = UISheetPresentationController.Detent.custom(resolver: { _ in
                let offsets: CGFloat = 18 + 36*2
                let itemsHeight: CGFloat = 26 * CGFloat(self.actions.count)
                let itemsSpacing: CGFloat = self.mainView.itemsStackView.spacing * CGFloat(self.actions.count-1)
                return offsets + itemsHeight + itemsSpacing
            })

            sheetPresentationController.prefersGrabberVisible = false
            sheetPresentationController.detents = [detent]

            loadViewIfNeeded()
        }
        
        func layout() {
            view.addSubviews([mainView])
            mainView.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(18 + (Device.safeAreaInsets?.bottom ?? 0))
                $0.leading.trailing.equalToSuperview().inset(6)
            }
        }
        
        func addItems() {
            actions.forEach{ action in
                let item = ItemStackView(action: action)
                item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionTap)))
                mainView.itemsStackView.addArrangedSubview(item)
            }
        }
    }
    
    @objc private func actionTap(_ recognizer: UITapGestureRecognizer) {
        recognizer.view
            .publisher
            .sink{ [weak self] view in
                guard let item = view as? ItemStackView else { return }
                self?.tap(action: item.action)
            }
            .store(in: &cancellable)
    }
    
    open func initialize() {
        
    }
    
    ///override하여 바인딩 구현
    open func bind() {
        
    }
    
    ///override를 통해 각 action에 대한 로직 작성이 필요
    open func tap(action: any BottomSheetAction){
        print(action)
    }
}


extension BaseBottomSheetViewController {
    
    public class BaseBottomSheetView: BaseView {
        
        public var itemViews: [ItemStackView] { itemsStackView.subviews.map{ $0 as! ItemStackView }}
        internal let itemsStackView: UIStackView = UIStackView(axis: .vertical, spacing: 20)
        
        public override func style() {
            layer.cornerRadius = 24
            backgroundColor = Color.white
        }
        
        public override func hierarchy() {
            addSubviews([itemsStackView])
        }
        
        public override func layout() {
            itemsStackView.snp.makeConstraints{
                $0.top.bottom.equalToSuperview().inset(36)
                $0.leading.trailing.equalToSuperview().inset(24)
            }
        }
    }
    
    public final class ItemStackView: BaseStackView {
        
        public var isDisabled: Bool = false {
            didSet {
                isUserInteractionEnabled = !isDisabled
                setElement()
            }
        }
        
        public let action: BottomSheetAction
        
        init(action: BottomSheetAction) {
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
        
        public override func style() {
            axis = .horizontal
            spacing = 14
            setElement()
        }
        
        public override func hierarchy() {
            addArrangedSubviews([iconImageView, titleLabel])
        }
        
        private func setElement() {
            iconImageView.image = isDisabled ? action.content.disabledIcon : action.content.defaultIcon
            titleLabel.textColor = isDisabled ? Color.black20 : Color.black
        }
    }
}
