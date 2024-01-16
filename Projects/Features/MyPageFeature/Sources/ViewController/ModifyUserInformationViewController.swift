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
import FeatureDependency

final class ModifyUserInformationViewController: BaseViewController<NavigateHeaderView, ModifyUserInformationView, DefaultMyPageCoordinator> {
    
    init() {
        super.init(headerView: NavigateHeaderView(title: "내 정보 수정"), mainView: ModifyUserInformationView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        
    }
    
}
