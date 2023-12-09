//
//  BottomSheetDelegate.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/09.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol BottomSheetDelegate: AnyObject {
    func show(_ sender: DelegateSender)
}
