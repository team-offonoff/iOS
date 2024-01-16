//
//  MyPageViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class MyPageViewController: BaseViewController<HeaderView, MyPageView, DefaultMyPageCoordinator> {
    
    init() {
        super.init(headerView: HeaderView(title: "MY"), mainView: MyPageView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
