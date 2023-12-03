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
import HomeFeatureInterface

final class TopicBottomSheetViewController: UIViewController{
    
    private let viewModel: any TopicBottomSheetViewModel
    
    init(viewModel: TopicBottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView: TopicBottomSheetView = TopicBottomSheetView()
    
    override func viewDidLoad() {
        modalSetting()
        layout()
        initialize()
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
        mainView.choiceResetItem?.isDisabled = !viewModel.canChoiceReset
    }
}
