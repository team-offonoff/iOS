//
//  ChoiceOptionDTO.swift
//  Data
//
//  Created by 박소윤 on 2023/12/11.
//  Copyright © 2023 AB. All rights reserved.
//

import Foundation
import Domain

enum ChoiceOptionDTO: String, Codable {
    case A = "CHOICE_A"
    case B = "CHOICE_B"
}

extension ChoiceOptionDTO: Domainable {
    func toDomain() -> Choice.Option {
        .init(rawValue: rawValue)!
    }
}

extension Choice.Option {
    func toDTO() -> String {
        switch self {
        case .A:    return ChoiceOptionDTO.A.rawValue
        case .B:    return ChoiceOptionDTO.B.rawValue
        }
    }
}
