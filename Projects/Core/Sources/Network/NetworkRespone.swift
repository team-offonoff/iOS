//
//  NetworkRespone.swift
//  Core
//
//  Created by 박소윤 on 2023/10/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation

public struct NetworkErrorRespone: Decodable {
    let code: String
    let content: ErrorContent
}

extension NetworkErrorRespone {
    
    enum CodingKeys: String, CodingKey {
        case code = "abCode"
        case content = "errorContent"
    }
    
    public struct ErrorContent: Decodable {
        let message: String
        let hint: String
        let httpCode: Int
    }
}
