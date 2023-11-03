//
//  HomeTabViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/09/25.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import ABKit
import UIKit
import FeatureDependency
import HomeFeatureInterface

final class HomeTabViewController: BaseViewController<HeaderView, HomeTabView, DefaultHomeCoordinator>{
    
    private let viewModel: HomeTabViewModel

    init(){
        self.viewModel = DefaultHomeTabViewModel()
        super.init(
            headerView: HeaderView(icon: Image.homeAlarmOff, selectedIcon: Image.homeAlarmOn),
            mainView: HomeTabView()
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainView.setBottomSheetDefaultY()
    }
    
    public override func style() {
        view.backgroundColor = Color.homeBackground
    }
    
    override func bind() {
        bindBottomSheetMove()
    }
    
    private func bindBottomSheetMove(){
        viewModel.canBottomSheetMovePublisher
            .receive(on: RunLoop.main)
            .sink{ canMove in
                self.mainView.chatBottomSheetFrame.isUserInteractionEnabled = canMove
            }.store(in: &cancellables)
    }
}
