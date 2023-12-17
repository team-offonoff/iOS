//
//  WritersCommentBottomSheetViewController.swift
//  HomeFeature
//
//  Created by 박소윤 on 2023/12/17.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import HomeFeatureInterface
import FeatureDependency
import Domain

public final class WritersCommentBottomSheetViewController: BaseBottomSheetViewController {
    
    public init(index: Int, viewModel: any WritersCommentBottomSheetViewModel) {
        self.index = index
        self.viewModel = viewModel
        super.init(actions: [Comment.Action.modify, Comment.Action.delete])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let index: Int
    private let viewModel: any WritersCommentBottomSheetViewModel
    
    public override func initialize() {
        
    }
    
    public override func bind() {
        viewModel.deleteItem
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellable)
    }
    
    public override func tap(action: BottomSheetAction) {
        switch action {
        case Comment.Action.modify:
            break
            
        case Comment.Action.delete:
            viewModel.delete(at: index)
        
        default:    fatalError()
        }
    }
    
}
