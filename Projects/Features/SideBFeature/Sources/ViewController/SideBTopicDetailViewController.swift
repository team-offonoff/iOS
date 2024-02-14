//
//  SideBTopicDetailViewController.swift
//  SideBFeature
//
//  Created by 박소윤 on 2024/02/14.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class SideBTopicDetailViewController: BaseViewController<NavigateHeaderView, SideBTopicDetailView, DefaultSideBCoordinator> {
    
    init(viewModel: SideBViewModel){
        self.viewModel = viewModel
        super.init(headerView: NavigateHeaderView(title: nil, icon: nil, selectedIcon: nil), mainView: SideBTopicDetailView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any SideBViewModel
    
    override func initialize() {
        mainView.topicCell.binding(data: .init(topic: viewModel.topics[0].topic))
    }
    
}
