//
//  CommentBottomSheetViewModel.swift
//  HomeFeatureInterface
//
//  Created by 박소윤 on 2023/12/12.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core
import FeatureDependency

public protocol CommentBottomSheetViewModel:
    CommentBottomSheetViewModelInput,
    CommentBottomSheetViewModelOutput,
    ErrorHandleable{
}

public protocol CommentBottomSheetViewModelInput {
    func viewDidLoad()
}

public protocol CommentBottomSheetViewModelOutput {
    var comments: [CommentListItemViewModel] { get }
    var reloadData: (() -> Void)? { get set }
}
