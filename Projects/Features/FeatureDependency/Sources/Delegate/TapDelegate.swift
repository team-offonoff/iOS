//
//  TapDelegate.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/15.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public protocol TapDelegate: AnyObject {
    func tap(_ recognizer: DelegateSender)
}
