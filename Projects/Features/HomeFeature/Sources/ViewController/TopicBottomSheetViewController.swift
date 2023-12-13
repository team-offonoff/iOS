//
//  TopicBottomSheetViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/03.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

import UIKit
import ABKit
import Combine

import HomeFeatureInterface

import Domain

protocol TopicBottomSheetGestureDelegate: AnyObject {
    func tap(action: TopicTemp.Action)
}

final class TopicBottomSheetViewController: UIViewController{
    
    private let viewModel: any TopicBottomSheetViewModel
    
    init(viewModel: TopicBottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellable: Set<AnyCancellable> = []
    private let mainView: TopicBottomSheetView = TopicBottomSheetView()
    
    override func viewDidLoad() {
        modalSetting()
        layout()
        initialize()
        bind()
    }

    private func modalSetting(){
        
        guard let sheetPresentationController = sheetPresentationController else { return }

        let detent = UISheetPresentationController.Detent.custom(resolver: { _ in
            return 190 + 18
        })

        sheetPresentationController.prefersGrabberVisible = false
        sheetPresentationController.detents = [detent]

        loadViewIfNeeded()
    }
    
    private func layout(){
        view.addSubviews([mainView])
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.height.equalTo(190)
            $0.leading.trailing.equalToSuperview().inset(6)
        }
    }
    
    private func initialize() {
        mainView.delegate = self
        mainView.choiceResetItem?.isDisabled = !viewModel.canChoiceReset
    }
    
    private func bind() {
        
        viewModel.successTopicAction
            .receive(on: DispatchQueue.main)
            .sink{ action in
                switch action {
                case .hide:
                    dismiss()
                case .report:
                    dismiss()
                case .reset:
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
}

extension TopicBottomSheetViewController: TopicBottomSheetGestureDelegate {
    func tap(action: TopicTemp.Action) {
        switch action {
        case .hide:
            viewModel.hideTopic()
        case .report:
            viewModel.reportTopic()
        case .reset:
            viewModel.resetChoice()
        default:
            fatalError("매개변수로 잘못된 액션 전달")
        }
    }
}
