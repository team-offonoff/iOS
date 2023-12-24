//
//  ChoiceOption+Mapping.swift
//  Data
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

extension Choice.Option {
    
    func toDTO() -> String {
        switch self {
        case .A:        return "CHOICE_A"
        case .B:        return "CHOICE_B"
        }
    }
    
    static func toDomain(_ dto: String?) -> Choice.Option? {
        Choice.Option.allCases.first(where: { $0.toDTO() == dto })
    }
}
