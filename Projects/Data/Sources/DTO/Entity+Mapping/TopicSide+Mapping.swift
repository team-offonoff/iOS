//
//  TopicSide+Mapping.swift
//  Data
//
//  Created by 박소윤 on 2023/12/24.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

extension Topic.Side {
    
    func toDTO() -> String {
        switch self {
        case .A:        return "TOPIC_A"
        case .B:        return "TOPIC_B"
        }
    }
        
    static func toDomain(_ dto: String) -> Topic.Side {
        Topic.Side.allCases.first(where: { $0.toDTO() == dto })!
    }
}
