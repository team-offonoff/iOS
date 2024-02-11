//
//  VoteDelegate.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/13.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public protocol VoteDelegate: AnyObject {
    func vote(_ option: Choice.Option, index: Int)
}
