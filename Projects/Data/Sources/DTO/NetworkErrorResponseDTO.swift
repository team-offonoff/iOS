//
//  NetworkResponseDTO.swift
//  Core
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

public struct NetworkErrorResponeDTO: Decodable {
    let code: String
    let content: ErrorContentResponseDTO
}

extension NetworkErrorResponeDTO {
    
    enum CodingKeys: String, CodingKey {
        case code = "abCode"
        case content = "errorContent"
    }
    
    public struct ErrorContentResponseDTO: Decodable {
        let message: String
        let hint: String
        let httpCode: Int
        let payload: Int?
    }
}

extension NetworkErrorResponeDTO: Domainable {

    public func toDomain() -> ErrorContent {
        .init(
            code: code,
            message: content.message,
            payload: content.payload
        )
    }
}
