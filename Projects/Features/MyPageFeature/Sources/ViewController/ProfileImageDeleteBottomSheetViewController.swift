//
//  ProfileImageDeleteBottomSheetViewController.swift
//  MyPageFeature
//
//  Created by 박소윤 on 2024/01/16.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import ABKit
import MyPageFeatureInterface

final class ProfileImageDeleteBottomSheetViewController: BaseBottomSheetViewController<ProfileImageDeleteBottomSheetView> {
    
    init(viewModel: DeleteProfileImageViewModel) {
        self.viewModel = viewModel
        super.init(mainView: ProfileImageDeleteBottomSheetView())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: DeleteProfileImageViewModel
    
    override func detent() -> CGFloat {
        183
    }
    
    override func initialize() {
        
        mainView.deleteItem.tapPublisher
            .sink{ [weak self] _ in
                self?.viewModel.deleteImage()
            }
            .store(in: &cancellable)
        
        mainView.cancelItem.tapPublisher
            .sink{ [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
            
    }
    
    override func bind() {
        viewModel.successDelete
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
    }
}
