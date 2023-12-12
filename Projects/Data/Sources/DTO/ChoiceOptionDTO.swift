//
//  ChoiceOptionDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain
import Core

enum ChoiceOptionDTO: String, Codable {
    case A = "CHOICE_A"
    case B = "CHOICE_B"
}

extension ChoiceOptionDTO: Domainable {
    
    func toDomain() -> ChoiceTemp.Option {
        .init(rawValue: rawValue)!
    }
}

extension ChoiceTemp.Option {
    func toDTO() -> String {
        switch self {
        case .A:    return ChoiceOptionDTO.A.rawValue
        case .B:    return ChoiceOptionDTO.B.rawValue
        }
    }
}
