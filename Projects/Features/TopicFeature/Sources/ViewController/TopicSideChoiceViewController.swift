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

    override func initialize() {
        [mainView.choice.noramlView, mainView.choice.aView, mainView.choice.bView].forEach{
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        }
    }
    
    @objc func tap(_ recognizer: UITapGestureRecognizer) {
        if recognizer.location(in: view).x < Device.width/2 {
            mainView.state = .A
        }
        else {
            mainView.state = .B
        }
    }
    
}
