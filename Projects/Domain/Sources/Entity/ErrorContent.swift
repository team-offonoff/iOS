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
        code: NetworkServiceError,
        message: String,
        payload: Int?
    ) {
        self.code = code
        self.message = message
        self.payload = payload
    }
    
    public let code: NetworkServiceError
    public let message: String
    public let payload: Int?
}
