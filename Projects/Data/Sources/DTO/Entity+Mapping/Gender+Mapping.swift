//
//  Gender+Mapping.swift
//  Data
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

extension Gender {
    
    func toDTO() -> String{
        switch self {
        case .man:      return "MALE"
        case .woman:    return "FEMALE"
        }
    }
    
    static func toDomain(_ dto: String) -> Gender? {
        Gender.allCases.first(where: { $0.toDTO() == dto })
    }
}
