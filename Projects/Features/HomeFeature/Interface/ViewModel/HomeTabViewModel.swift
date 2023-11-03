//
//  HomeTabViewModel.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/09/26.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public protocol HomeTabViewModel {
    var canBottomSheetMovePublisher: Published<Bool>.Publisher { get }
    func viewDidLoad()
}
