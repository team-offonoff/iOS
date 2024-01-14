//
//  BaseBottomSheetViewController.swift
//  ABKit
//
//  Created by 박소윤 on 2024/01/13.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import Combine

open class BaseBottomSheetViewController<V: UIView>: UIViewController {
    
    public init(mainView: V){
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///기본 값은 UIEdgeInsets(top: 0, left: 6, bottom: 18, right: 6) 입니다.
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 18, right: 6)
    public let mainView: V
    public var cancellable: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        
        modalSetting()
        style()
        initialize()
        layout()
        bind()
        
        func modalSetting() {
           
            guard let sheetPresentationController = sheetPresentationController else { return }

            let detent = UISheetPresentationController.Detent.custom(resolver: { _ in
                return self.detent()
            })

            sheetPresentationController.prefersGrabberVisible = false
            sheetPresentationController.detents = [detent]

            loadViewIfNeeded()
        }
        
        func layout() {
            view.addSubviews([mainView])
            mainView.snp.makeConstraints{
                $0.bottom.equalToSuperview().inset(insets.bottom + (Device.safeAreaInsets?.bottom ?? 0))
                $0.leading.equalToSuperview().offset(insets.left)
                $0.trailing.equalToSuperview().inset(insets.right)
            }
        }
    }
    
    open func detent() -> CGFloat {
        0
    }
    
    open func style() {
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.backgroundColor = Color.white
    }
    
    open func initialize() {
        
    }
    
    ///override하여 바인딩 구현
    open func bind() {
        
    }
}
