//
//  ModifyUserInformationViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import MyPageFeatureInterface
import FeatureDependency
import Domain

final class ModifyUserInformationViewController: BaseViewController<NavigateHeaderView, ModifyUserInformationView, DefaultMyPageCoordinator> {
    
    init(viewModel: any ModifyUserInformationViewModel) {
        self.viewModel = viewModel
        super.init(headerView: NavigateHeaderView(title: "내 정보 수정"), mainView: ModifyUserInformationView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any ModifyUserInformationViewModel
    
    override func initialize() {

        jobMenu()
        
        func jobMenu() {
            mainView.jobView.contentView.menu = {
                let children = Job.allCases.map{ type in
                    let action = UIAction(title: type.rawValue, handler: { action in
                        self.viewModel.jobSubject.send(type)
                    })
                    return action
                }
                return UIMenu(title: "", children: children)
            }()
        }
    }
    
    override func bind() {
        
        bindJobSelection()
        
        func bindJobSelection() {
            viewModel.jobSubject
                .sink{ [weak self] job in
                    self?.mainView.jobView.contentView.update(text: job.rawValue)
                }
                .store(in: &cancellables)
        }
    }
}
