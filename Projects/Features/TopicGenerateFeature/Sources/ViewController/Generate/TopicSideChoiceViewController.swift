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
import TopicGenerateFeatureInterface
import FeatureDependency

final class TopicSideChoiceViewController: BaseViewController<ModalityHeaderView,TopicSideChoiceView,DefaultTopicGenerateCoordinator> {

    init(viewModel: any TopicGenerateViewModel) {
        self.viewModel = viewModel
        super.init(headerView: ModalityHeaderView(title: "토픽 생성"), mainView: TopicSideChoiceView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any TopicGenerateViewModel

    override func initialize() {
        
        addTarget()
        addGestureRecognizer()
        
        func addTarget() {
            mainView.ctaButton.tapPublisher
                .sink{ [weak self] _ in
                    guard let self = self, let state = self.mainView.state else { return }
                    self.viewModel.topicSide.send(state)
                    self.coordinator?.startTopicGenerate()
                }
                .store(in: &cancellables)
        }
        
        func addGestureRecognizer() {
            [mainView.sideChoice.noramlView, mainView.sideChoice.aView, mainView.sideChoice.bView].forEach{
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
            }
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
