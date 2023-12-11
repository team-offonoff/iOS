//
//  ErrorContent.swift
//  Domain
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct ErrorContent {
    
    public init(
        code: SerivceError,
        message: String
    ) {
        self.code = code
        self.message = message
    }
    
    public let code: SerivceError
    public let message: String
}
