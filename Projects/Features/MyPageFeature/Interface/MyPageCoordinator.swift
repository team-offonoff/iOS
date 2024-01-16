//
//  MyPageCoordinator.swift
//  MyPageFeatureInterface
//
//  Created by 박소윤 on 2024/01/15.
//  Copyright © 2024 AB. All rights reserved.
//

import Foundation
import FeatureDependency

public protocol MyPageCoordinator: Coordinator {
    func startModifyInformation()
    func startProfileImageActionBottomSheet()
    func startDeleteProfileImageBottomSheet()
}
