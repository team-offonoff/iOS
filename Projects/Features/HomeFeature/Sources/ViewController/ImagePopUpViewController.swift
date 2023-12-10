//
//  ImagePopUpViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/10.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency
import Domain

final class ImagePopUpViewController: BaseViewController<BaseHeaderView, ImagePopUpView, DefaultHomeCoordinator> {
    
    private let choice: Choice
    
    init(choice: Choice) {
        self.choice = choice
        super.init(headerView: BaseHeaderView(), mainView: ImagePopUpView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.mainView.transform = .identity
            self?.mainView.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.mainView.transform = .identity
            self?.mainView.isHidden = true
        }
    }
    
    override func style() {
        view.backgroundColor = Color.black60
    }
    
    override func initialize() {
        
        modifyHeader()
        addCloseTarget()
        mainView.fill(choice)
        
        func modifyHeader() {
            headerView.snp.updateConstraints{
                $0.height.equalTo(0)
            }
            mainView.snp.updateConstraints{
                $0.top.equalTo(headerView.snp.bottom).offset(-(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
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
