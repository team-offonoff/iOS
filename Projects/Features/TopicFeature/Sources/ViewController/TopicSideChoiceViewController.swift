//
//  TopicSideChoiceViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import FeatureDependency

final class TopicSideChoiceViewController: BaseViewController<ModalityHeaderView,TopicSideChoiceView,DefaultTopicGenerateCoordinator> {
    
    init() {
        super.init(headerView: ModalityHeaderView(title: "토픽 생성"), mainView: TopicSideChoiceView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
