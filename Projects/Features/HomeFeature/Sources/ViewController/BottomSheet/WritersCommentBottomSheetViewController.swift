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
    
    public init(viewModel: any WritersCommentBottomSheetViewModel) {
        self.viewModel = viewModel
        super.init(actions: [Comment.Action.modify, Comment.Action.delete])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let viewModel: any WritersCommentBottomSheetViewModel
    
    public override func initialize() {
        
    }
    
    public override func bind() {
        
    }
    
    public override func tap(action: BottomSheetAction) {
        switch action {
        case Comment.Action.modify:
            break
            
        case Comment.Action.delete:
            break
        
        default:    fatalError()
        }
    }
    
}
