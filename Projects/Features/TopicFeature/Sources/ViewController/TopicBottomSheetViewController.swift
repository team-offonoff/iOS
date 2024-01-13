//
//  TopicBottomSheetViewController.swift
//  TopicFeature
//
//  Created by 박소윤 on 2023/12/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import Combine
import TopicFeatureInterface
import FeatureDependency
import Domain

public final class TopicBottomSheetViewController: BaseBottomSheetViewController {
    
    public init(viewModel: TopicBottomSheetViewModel){
        self.viewModel = viewModel
        super.init(actions: [Topic.Action.hide, Topic.Action.report, Topic.Action.revote])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: TopicBottomSheetViewModel
    
    public override func initialize() {
        
        setResetEnableState()
        
        func setResetEnableState() {
            guard let index = actions.map({ $0 as! Topic.Action }).firstIndex(where: { $0 == Topic.Action.revote }) else { return }
            mainView.itemViews[index].isDisabled = !viewModel.canRevote
        }
    }
    
    public override func bind() {
        viewModel.successTopicAction
            .receive(on: DispatchQueue.main)
            .sink{ action in
                switch action {
                case .hide:
                    dismiss()
                case .report:
                    dismiss()
                default:
                    fatalError()
                }
            }
            .store(in: &cancellable)
        
        func dismiss() {
            self.dismiss(animated: true)
        }
    }
    
    public override func tap(action: BottomSheetAction) {
        guard let action = action as? Topic.Action else { return }
        switch action {
        case .hide:
            viewModel.hideTopic()
        case .report:
            viewModel.reportTopic()
        case .revote:
            NotificationCenter.default.post(name: Notification.Name(Topic.Action.revote.identifier), object: viewModel)
            self.dismiss(animated: true)
        default:
            fatalError("매개변수로 잘못된 액션 전달")
        }
    }
}
