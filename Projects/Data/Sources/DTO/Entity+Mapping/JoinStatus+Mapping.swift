//
//  JoinStatus+Mapping.swift
//  Data
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

extension JoinStatus {

    func toDTO() -> String {
        switch self {
        case .empty:                return "EMPTY"
        case .authRegistered:       return "AUTH_REGISTERED"
        case .personalRegistered:   return "PERSONAL_REGISTERED"
        case .complete:             return "COMPLETE"
        }
    }
    
    static func toDomain(_ dto: String) -> JoinStatus {
        JoinStatus.allCases.first(where: { $0.toDTO() == dto })!
    }
}
