//
//  OthersCommnetBottomSheetViewController.swift
//  CommentFeature
//
//  Created by 박소윤 on 2023/12/17.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import UIKit
import ABKit
import CommentFeatureInterface
import FeatureDependency
import Domain

public final class OthersCommnetBottomSheetViewController: ActionBottomSheetViewController {
    
    public init(index: Int, viewModel: any OthersCommentBottomSheetViewModel) {
        self.index = index
        self.viewModel = viewModel
        super.init(actions: [Comment.Action.report])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let index: Int
    private let viewModel: any OthersCommentBottomSheetViewModel
    
    public override func bind() {
        
    }
    
    public override func tap(action: BottomSheetAction) {
        switch action {
        case Comment.Action.report:
            break
        default:    fatalError()
        }
    }
    
}
