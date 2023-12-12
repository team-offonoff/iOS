//
//  ErrorHandleable.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Combine
import Domain

public protocol ErrorHandleable {
    var errorHandler: PassthroughSubject<ErrorContent, Never> { get }
}
