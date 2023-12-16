//
//  DelegateSender.swift
//  FeatureDependency
//
//  Created by 박소윤 on 2023/12/09.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct DelegateSender {
    
    public init(
        identifier: String,
        data: Any? = nil
    ) {
        self.identifier = identifier
        self.data = data
    }
    
    public let identifier: String
    public let data: Any?
}
