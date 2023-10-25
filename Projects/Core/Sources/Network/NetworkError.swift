//
//  NetworkError.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noAuthToken
    case invalidResponse(statusCode: Int)
    case sessionError
    case jsonParseFailed
    case exceptionParseFailed
    case exception(errorMessage: String)
    case responseConvertFailed
}
