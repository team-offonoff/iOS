//
//  ErrorHandleable.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine

public protocol ErrorHandleable {
    var errorSubject: PassthroughSubject<String, Never> { get }
}
