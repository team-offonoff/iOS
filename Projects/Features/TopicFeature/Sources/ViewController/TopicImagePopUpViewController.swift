//
//  ImagePopUpViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

public final class TopicImagePopUpViewController: BaseViewController<BaseHeaderView, ImagePopUpView, NullCoordinator> {
    
    public init(choice: Choice) {
        super.init(headerView: nil, mainView: ImagePopUpView())
        mainView.fill(choice)
    }
    
    public init(option: Choice.Option, image: UIImage) {
        super.init(headerView: nil, mainView: ImagePopUpView())
        mainView.fill(option: option, image: image, isPreview: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.mainView.transform = .identity
            self?.mainView.isHidden = false
        }
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.mainView.transform = .identity
            self?.mainView.isHidden = true
        }
    }
    
    public override func style() {
        view.backgroundColor = Color.black60
    }
    
    public override func initialize() {
        
        modifyViewLayout()
        addCloseTarget()
        
        func modifyViewLayout() {
            mainView.snp.remakeConstraints{
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        func addCloseTarget() {
            mainView.closeButton.tapPublisher
                .sink{ [weak self] _ in
                    self?.dismiss(animated: false)
                }
                .store(in: &cancellables)
        }
    }
    
}
